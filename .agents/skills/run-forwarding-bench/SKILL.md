---
name: run-forwarding-bench
description: Run a full FreeBSD network forwarding/firewall benchmark in this netbenches repo end-to-end — from bench-lab.sh through ministat, gnuplot, and the result README linked from the top-level site map. Use when the user asks to run a forwarding/firewall/IPsec/VPN bench on a DUT, add a new result set, or reproduce an existing one. Encodes the lab topology, the netmap link-bounce gotcha, and the RSS+netisr tuning trap.
---

# run-forwarding-bench

End-to-end procedure for producing one result set under
`<CPU>_<Cores>Cores/<NIC>/<topic>/results/<label>/`. The house workflow
is in the repo `CLAUDE.md` ("Assembling a new bench"); this skill adds
the operational detail and the two traps that cost real time.

## 0. Confirm scope before running (AskUserQuestion)

A full firewall bench is 7 config-sets x inet4/inet6 x N iterations x
reboot-per-run = ~1-2 h of physical DUT time. Do not launch silently.
Confirm:

1. **Machine dir** — which `<CPU>_<Cores>Cores/<NIC>/<topic>/` to run in.
2. **Bench config** — the `bench-lab-*.config` (`-f`). Read its ASCII
   topology diagram before touching it.
3. **Result label** — `results/<label>/`; match the platform's existing
   `fbsd<major>-<tag>` pattern. Encode notable tuning in the suffix
   (e.g. `.option-RSS.net.isr`).
4. **pkt-gen preset** (`-p`) — a subdir of `pktgen.configs/`
   (`RFC2544`, `dualstack-2k`, `flows-*`, `inet6-2k`, …).
5. **Iterations** (`-n`, min 3, default 5).

**Exception — autonomy mode.** If the user granted "run uninterrupted"
/ "no questions", skip the questions and use sane defaults (n=5,
existing config).

## 1. Show the command, then run it

Always print the exact `bench-lab.sh` invocation for review first.
Run from the machine's bench-topic dir:

```
../../../scripts/bench-lab.sh \
    -f ../bench-lab-2nodes.config \
    -c configs \
    -p ../../../pktgen.configs/<preset> \
    -n 5 \
    -d /tmp/benchs \
    -r you@example.com
```

- `-y` skips the interactive "clean up results dir" confirm (added for
  unattended runs).
- The results-dir guard trips if any filename under `-d` contains the
  string `bench`. **Put any launch log OUTSIDE the results dir**
  (e.g. `results/run-<label>.log`, not inside `results/<label>/`).
- Backgrounding: launch with `run_in_background`, then Monitor the
  receiver log filtered to config-set boundaries + PASS/FAIL. Do NOT
  stream raw per-second pps lines — the monitor gets killed for volume.

## 2. TRAP: netmap link-bounce -> 0 pps  (already fixed, know why)

Opening an igb interface in netmap mode (`pkt-gen -f rx`) **bounces the
link** (~2-4 s renegotiation). The harness fires receiver then sender
over two independent SSH sessions; on a fast host the sender's whole
blast lands during the receiver's link-down window => **0 pps
received**. Signature in the receiver log:

```
receiver_body [....] waiting for initial packets, poll returns 0 0
```

Fixed in `scripts/bench-lab.sh` with a `sleep 5` between receiver-start
and sender-start. If you see 0-pps iterations, verify that sleep is
still present before chasing anything else. See memory `netmap-link-bounce`.

## 3. TRAP: option RSS forces netisr tuning

**Check whether the running DUT kernel has `option RSS`** —
authoritatively, via the compiled-in kernel config:

```
sysctl -n kern.conftxt | grep -iE 'options[[:space:]]+RSS'
```

Match => `option RSS` is enabled. **Do not use the `net.inet.rss.*`
sysctls to decide this**: those OIDs exist whenever the RSS *framework*
is compiled in, independent of `option RSS`, so they are present even on
a no-RSS kernel. `net.isr.dispatch: direct` (vs `hybrid`) is a
corroborating signal but `kern.conftxt` is the source of truth. This
also matters for result labels: a run labeled `no-RSS` must be verified
this way before benching, or it is mislabeled.

If the DUT kernel is built with `option RSS` (BSDRP appliance images
are), IP/IPv6 input is hardwired to **hybrid dispatch**. With the
post-2015 default `net.isr.maxthreads=1` a single workstream on cpu0
consumes every RSS bucket => the IP queue overflows (~95% QDrops) and
throughput collapses ~10x. Before benching, ensure each config-set's
`boot/loader.conf.local` has:

```
net.isr.maxthreads="-1"    # one workstream per CPU
net.isr.bindthreads="1"    # pin each to its CPU
```

Verify on the live DUT with `netstat -Q`: >1 workstream row, `QDrops`
staying at 0. Full mechanism: `~/myscripts/FreeBSD/doc/netisr_kernel_service.md`
and `RSS_kernel_option.md`.

## 3b. PMC profiling + flamegraph (proving *where* the cost is)

When a throughput delta needs a mechanism (e.g. "removing `option RSS`
sped forwarding up — prove it's the netisr path"), capture a CPU-cycle
flamegraph under load on each kernel and diff them.

Use the harness's built-in PMC mode rather than hand-driving pmcstat —
it sequences load and capture correctly:

```
env PMC=true PMC_EVENT=BU_CPU_CLK_UNHALTED \
  ../../scripts/bench-lab.sh -f <cfg> -c <one-config-dir> -p <one-pktgen-dir> \
  -n 1 -y -P -d /tmp/pmc-<label>
```

- `-P` enables PMC mode; `PMC=true` and `PMC_EVENT` must ALSO be in the
  env (the `-P` flag and the env var are both read — set both). PMC mode
  bypasses the min-3-iterations check, so `-n 1` is fine for one clean
  capture.
- **Restrict scope**: point `-c` at a dir containing only the one
  config-set (e.g. copy just `configs/forwarding` to `/tmp/pmc-cfg/`)
  and `-p` at a dir with only `inet4`. Keep the config-set BYTE-IDENTICAL
  across the two kernel runs so only the kernel differs.
- **`/data` is required and is a separate partition** on BSDRP (root is
  read-only UFS). It is not mounted by default; the harness runs
  `mount /data` itself. If a bare `mount` shows no `/data`, that is
  normal — `mount /data` succeeds (gpt/data, ~11G). Do NOT try to write
  PMC output under `/` or `/tmp` via the harness; it hardcodes `/data`.
- The harness runs `pmcstat -z 50 -S ${PMC_EVENT} -l 20 -O /data/pmc.out`
  during the blast, converts with `pmcstat -R ... -z16 -G /data/pmc.graph`,
  and downloads `bench.*.pmc.out` + `bench.*.pmc.graph` into `-d`.

**TRAP: the `-l 20` window can miss the blast entirely.** The harness
starts pmcstat at the top of `bench()` — *before* the reboot settles and
the receiver/`sleep 5`/sender sequence — so the 20 s sample window and
the ~60 s traffic blast only overlap by luck of reboot timing. When they
don't overlap the capture is **~95-97% `cpu_idle`/`sched_ule_idletd`**
with a few thousand non-idle samples that are SSH/pagezero noise, not the
forwarding path. Always verify a capture caught load before trusting it:

```
stackcollapse-pmc.pl bench.<...>.pmc.graph > folded.txt
awk '/cpu_idle|idletd|acpi_cpu_c1/{i+=$NF}{s+=$NF}END{printf "idle %.1f%% non-idle %d\n",100*i/s,s-i}' folded.txt
# top non-idle leaves MUST be iflib_rxeof / ip_tryforward / ether_output, not pmc*/pagezero
awk '/cpu_idle|idletd|acpi_cpu_c1/{next}{n=split($1,a,";");c[a[n]]+=$NF}END{for(k in c)print c[k],k}' folded.txt|sort -rn|head
```

Fix: widen the window with the `PMC_DURATION` env var (added to
`bench-lab.sh`; defaults to 20). Set `PMC_DURATION=50` so a 50 s window
covers the first 50 s of the 60 s blast regardless of reboot jitter:
`env PMC=true PMC_EVENT=... PMC_DURATION=50 bench-lab.sh ... -P`.

Do NOT try to hand-drive pmcstat over SSH during the blast instead: at
line rate the DUT control plane is starved, SSH commands time out (a bare
`ssh dut uptime` can hang 2 min), and a `nohup pmcstat &` launched through
a timed-out SSH never actually runs. The harness path is the only reliable
one because it sequences reboot -> config -> load -> capture in one flow.
See memory `pmc-window-vs-blast`.

Compare captures by **share of non-idle cycles**, not raw counts (total
sample count varies with idle fraction). The RSS discriminator is the
presence of `toeplitz_hash` / `rss_*` frames (≈11% of non-idle on an
option-RSS kernel, **0%** without). Note `netisr_dispatch_src` appears
twice per L2->L3 stack (ether_input then ip_input) on BOTH kernels — that
nesting is NOT a hybrid-dispatch signature; the RSS frames are.

**Event name is CPU-specific.** On the APU2's AMD GX-412T (Jaguar core)
the cycles event is **`BU_CPU_CLK_UNHALTED`** (confirm with
`pmccontrol -L` after `kldload hwpmc`). Intel parts use
`cpu_clk_unhalted.thread_p` / `.thread`. There is also a generic
`cycles`; prefer the vendor event to match the existing configs.

**Flamegraph** (scripts are installed system-wide in `/usr/local/bin`):

```
pmcstat -R bench.<...>.pmc.out -z16 -G stacks.txt   # if you need to re-fold
stackcollapse-pmc.pl bench.<...>.pmc.graph > folded.txt
flamegraph.pl folded.txt > forwarding.<kernel-label>.svg
```

Capture both kernels (no-RSS and option-RSS) with the same event and
duration, then compare the `netisr`/`ether_input`/`ip_input` frame
widths. That width delta is the proof that the throughput change came
from the netisr dispatch path, not elsewhere. Feeds
`~/myscripts/FreeBSD/doc/netisr_kernel_service.md` and
`RSS_kernel_option.md`.

## 4. Post-process: ministat

```
../../../scripts/bench-lab-ministat.sh /tmp/benchs
```

Produces `results/<label>/gnuplot.data` (`#index median minimum maximum`)
plus per-config `.pps` files. Requires `ministat(1)` on the host.

## 5. Plot

For a dualstack (inet4+inet6) firewall graph the plt reads two files,
`inet4.data` and `inet6.data`. `gnuplot.data` carries rows suffixed
`.inet4` / `.inet6`; split them, stripping the suffix and preserving
row order:

```
awk '/\.inet4 /{sub(/\.inet4/,"");print}' gnuplot.data > inet4.data
awk '/\.inet6 /{sub(/\.inet6/,"");print}' gnuplot.data > inet6.data
```

Copy `gnuplot.plt` from the closest existing result dir (the
`fbsd12-stable.r354440.BSDRP.1.96` firewall dir is a good template),
then edit only the `set title` and `set xlabel` lines. Generate:

```
gnuplot gnuplot.plt   # writes graph.png (needs full gnuplot, not gnuplot-lite)
```

Verify graph.png visually (grouped inet4/inet6 bars, error bars, dual
y-axis pps + IMIX throughput, the min-req reference line).

## 6. README + site map

Write `results/<label>/README.md` matching the platform's existing
result READMEs: hardware, kernel/image label, packet profile, load,
notable sysctls, then the inline image embed `![...](graph.png)` (that
IS the graph link — GitHub renders it). Document whatever the label's
suffix advertises (e.g. the net.isr finding).

Link it from the top-level `README.md` under the matching bench
category, alongside the platform's other entries. Label each link with
its FreeBSD version + notable tuning so old and new results stay
distinguishable.

## 7. Do not commit

Per repo CLAUDE.md: never `git commit`/`push` unless the user asks.
Leave the new files staged-or-untracked and state what was produced.

## Environment note

This repo runs claude via the FreeBSD linuxlator. `mkdir`/Write on
`/usr/home/...` paths can hit `EACCES` (path-mapping quirk); use the
`/home/olivier/...` equivalent instead. Writing to `/tmp` via the Write
tool can also fail — use a Bash heredoc for /tmp files.
