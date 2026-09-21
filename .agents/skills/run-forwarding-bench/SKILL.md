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
- **`-d` must already exist.** `bench-lab.sh:692` only tests
  `[ -d "${RESULTS_DIR}" ]`; it never creates it. A fresh `-d` path dies
  instantly with `EXIT: Can't found directory <path>`. `mkdir -p` it first.
- Backgrounding: launch with `run_in_background`, then Monitor the
  receiver log filtered to config-set boundaries + PASS/FAIL. Do NOT
  stream raw per-second pps lines — the monitor gets killed for volume.
- **Re-tailing the same log replays stale lines.** A `tail -F` monitor left
  over from a failed launch re-emits the *previous* run's `EXIT:` line and
  looks like a fresh failure. TaskStop the old monitor and start the new one
  with `tail -n 0 -F`. Confirm a failure against the log itself, not a
  monitor event.

## 1b. TRAP: ping and ssh resolve node names differently

The harness reaches the nodes two different ways, and they do **not** share
name resolution. Get this wrong and it dies in preflight, before any traffic:

- `icmp_test_all` (`bench-lab.sh:547`) runs plain `ping -c 2 "${HOST}"`.
  `ping(8)` ignores `~/.ssh/config` and, on FreeBSD, is IPv4-only.
- `rcmd` (`bench-lab.sh:201`) runs `ssh`, which *does* apply
  `~/.ssh/config` — including `User`, `IdentityFile`, and `HostName`
  rewrites.

On this lab the names are **AAAA-only in DNS** (no A record), so nothing
that needs IPv4 can resolve them, and `~/.ssh/config` carries
`Host apu* sm*` with `HostName %h.lab.cochard.me`. Consequences:

| `*_ADMIN` value | harness `ping` | harness `ssh` (`rcmd`) |
|---|---|---|
| `apu2-2` (short) | **NOK** — no A record | OK via `Host apu* sm*` |
| `apu2-2.lab.cochard.me` | OK | **NOK** — `%h` re-appends => `...lab.cochard.me.lab.cochard.me` |
| `192.168.100.42` (mgmt IP) | OK | OK **only with an IP stanza** (below) |

**No single naming form satisfies both.** The working combination:

1. Put bare mgmt IPs in `bench-lab-*.config` (keep the hostname as a
   trailing comment). The sibling 3-node configs already do this — now you
   know why.
2. Give ssh an IP-keyed stanza, or a bare IP loses the `User root` +
   `IdentityFile` it was inheriting from the `Host apu*` block:

```
Host 192.168.100.42 192.168.100.4
  IdentityFile ~/.ssh/lab
  IdentitiesOnly yes
  User root
```

Without step 2 the failure is misleading: `rcmd`'s `uname` test
(`bench-lab.sh:564`) fails, so the script falls into its key-push branch,
finds no `~/.ssh/id_rsa.pub` / `id_dsa.pub` (the lab key is `~/.ssh/lab`)
and dies `EXIT: Didn't found user public SSH key` — which sounds like a
missing key, not a missing `User`/`IdentityFile`.

**Verify all three before launching**, reusing the harness's own logic
rather than a hand-rolled `ssh` (and note `$?` after a pipeline is the
*pipeline's* status — a `ssh ... | head` that prints nothing can still
report 0):

```
. ./bench-lab-2nodes.config
for H in ${SENDER_ADMIN} ${DUT_ADMIN}; do ping -c2 "$H" >/dev/null 2>&1 \
  && echo "ping $H OK" || echo "ping $H NOK"; done
ssh -o BatchMode=yes "${DUT_ADMIN}" 'uname; whoami'      # expect: FreeBSD root
```

Also confirm the mgmt IP from the node itself (`ifconfig igb0`) rather than
copying it from a sibling config — `sm1` is `192.168.100.4`, while
`bench-lab-3nodes.equilibrium.config` lists `.43` as its sender.

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

**Do not grep for `poll returns 0 0` alone** — that line appears during
normal startup in *every* healthy receiver file, while the receiver waits
for the first packets. Grepping it bare flags all 5 iterations of a perfect
run. The failure signature is that line *plus* no real rate afterwards, so
check the mid-blast rate instead:

```
for f in bench.*.receiver; do
  med=$(grep -oE '^[0-9.]+ main_thread .* [0-9]+ pps' "$f" | awk '{print $4}' \
        | sed -n '16,$p' | head -30 | sort -n \
        | awk '{a[NR]=$1}END{if(NR)print a[int((NR+1)/2)]; else print "NODATA"}')
  printf '%-46s %s\n' "$(basename $f)" "$med"
done
```

Also ignore the *last* rate line: it is the blast tapering off as the sender
drains, routinely a fraction of the median, which is exactly why
`bench-lab-ministat.sh` drops the first 15 and last 10 lines. Judge an
iteration on its mid-blast median, never its final line.

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

Partial fix: widen the window with the `PMC_DURATION` env var (added to
`bench-lab.sh`; defaults to 20). `PMC_DURATION=50` makes a 50 s window cover
most of the 60 s blast regardless of reboot jitter:
`env PMC=true PMC_EVENT=... PMC_DURATION=50 bench-lab.sh ... -P`.

**But widening the window is NOT sufficient at line rate, and the harness
`-P` path alone cannot produce a usable firewall profile on the APU2.**
Measured 2026-09-21 on n313366 with `PMC_DURATION=50`: the window landed on
the blast (top leaves were `iflib_rxeof` / `ip_tryforward` / `ether_output`,
so not a miss) yet the capture was still **96.5% idle with only 7918 non-idle
samples of 226896**, and pmcstat warned
`at least 2325567 events were discarded`. At gigabit line rate the 4-core
APU2 saturates, userland pmcstat starves, and hwpmc's per-CPU buffers
overflow — so the samples that survive are dominated by pmcstat's own
`pmc_process_samples` / `pmclog_process_callchain`. A 96%-idle capture is
unusable no matter which frames appear at the top.

Two distinct failure modes, distinguish them before "fixing" anything:

| symptom | cause | fix |
|---|---|---|
| ~95-97% idle, top leaves are `pmc*`/`pagezero`/SSH | window missed the blast | `PMC_DURATION=50` |
| ~95-97% idle, top leaves ARE the forwarding path, `events were discarded` warning | DUT saturated, pmcstat starved + buffer overflow | capture at sub-saturation (below) |

**Reference for a healthy capture** (`simple_tx/results/fbsd16-n311215.D58513/PMC/`):
**411k-668k non-idle samples, 32-58% idle**. Anything in the single-digit
thousands of non-idle samples is noise, not a profile.

**The method that works: rate-limit the sender and drive pmcstat mid-blast.**
Offer ~300 Kpps with pkt-gen's `-R` flag (below every forwarding ceiling on
this hardware), let the blast reach steady state ~12 s, then run pmcstat over
SSH. Cycle *proportions* are rate-independent, which is what a flamegraph
diagnoses. This is how the D58513 profiles were made (~990k samples each).

Caveat to state in any write-up: a sub-saturation profile will not show
saturation-only effects (e.g. lock contention that only appears once queues
back up). Accept that limit or the capture does not happen at all.

**Correction to earlier guidance in this skill:** hand-driving pmcstat over
SSH is fine *at sub-saturation* — the DUT control plane is responsive at
300 Kpps. The "SSH times out, never use it" warning applies only to
**line-rate** captures, where a bare `ssh dut uptime` can hang 2 min. Do not
read it as a blanket prohibition; at line rate the harness path is the only
reliable sequencer, but at line rate the capture is worthless anyway.

**Driving it yourself means reimplementing `upload_cfg`, including the
read-only root.** BSDRP's `/` is read-only UFS: a plain
`scp -r configs/<set>/* root@dut:/` fails with
`scp: dest open "/boot/loader.conf.local": Failure`. The harness sequence
(`bench-lab.sh:504` `upload_cfg`) is:

```
ssh dut 'mount -uw /'        # only needed when the set has a boot/ dir
scp -r <set>/* root@dut:/
ssh dut 'mount -ur /'        # MANDATORY, see below
ssh dut 'config save'
ssh dut reboot
```

The remount back to read-only is not cosmetic: left rw, the reboot writes an
`/entropy` file and the *next* boot panics when `dd` reads it (comment at
`bench-lab.sh:524`). Always restore ro even on the scp-failure path.

See memory `pmc-window-vs-blast`.

**Validated driver** (2026-09-21, n313366: 625494 non-idle samples, 58.2%
idle, no discard warning — vs 7918 / 96.5% from the harness `-P` path at line
rate). Per config-set: upload, reboot, receiver, `sleep 5`, rate-limited
sender, settle, sample.

```sh
. ../bench-lab-2nodes.config
RATE=300000; EVENT=BU_CPU_CLK_UNHALTED; DUR=30
# read-only root dance (see below), then reboot and wait for ssh
ssh $DUT_ADMIN 'mount -uw /' && scp -q -r <set>/* $DUT_ADMIN:/ \
  && ssh $DUT_ADMIN 'mount -ur /' && ssh $DUT_ADMIN 'config save' \
  && ssh $DUT_ADMIN reboot
# ... wait for the DUT, then kldload hwpmc + mount /data ...
ssh $RECEIVER_ADMIN "pkt-gen -N -f rx -i $RECEIVER_LAB_IF -w 2 -W" &
sleep 5                                   # netmap link-bounce guard
ssh $SENDER_ADMIN "pkt-gen -f tx -N -i $SENDER_LAB_IF -n 0 -l 60 -4 -R $RATE \
  -d $RECEIVER_LAB_NET -D $DUT_LAB_IF_MAC_SENDER_SIDE \
  -s $SENDER_LAB_NET -S $SENDER_LAB_MAC -w 2" &
sleep 12                                  # let the blast reach steady state
ssh $DUT_ADMIN "pmcstat -z 50 -S $EVENT -l $DUR -O /data/pmc.out"
ssh $DUT_ADMIN "pmcstat -R /data/pmc.out -z16 -G /data/pmc.graph"
```

Confirm the rate actually landed and the DUT did not drop: sender ~300 Kpps
and receiver within ~1% of it. If the receiver trails, the DUT is the
bottleneck and the capture is no longer sub-saturation.

**Pick the rate PER CONFIG-SET, against that config's own ceiling — not one
rate for the whole sweep.** A firewall sweep spans a 3.6x throughput range
(on n313366: ipf-stateful 268k … forwarding 966k), so a single rate that is
comfortable for the fast configs saturates the slow ones. Measured
2026-09-21 at a flat `-R 300000`: `ipf-stateless` (436k ceiling),
`ipfw-stateful` (567k) and `ipfw-stateless` (741k) captured clean
(625k-1273k non-idle, received == offered), while `ipf-stateful` (268k
ceiling) received only 283k, `pf-stateless` (279k) only 287k, and
`pf-stateful` (305k) only 238k — all three saturated, sshd starved, and the
pmcstat ssh died with `Connection timed out during banner exchange`, leaving
no `/data/pmc.graph` to fetch.

Rule of thumb: offer ~50-70% of the config's measured median from
`gnuplot.data`. Re-ran the three slow sets at `-R 150000` and they captured
clean. Absolute sample counts then differ between configs; compare by share
of non-idle cycles, which is rate-independent.

Then per config:

```
stackcollapse-pmc.pl <cfg>.pmc.graph > <cfg>.folded.txt
flamegraph.pl <cfg>.folded.txt > <cfg>.svg
```

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

On a first run against a fresh `-d` the script prints two harmless lines
before doing its work — ignore them, they are not failures:

```
rm: /tmp/<dir>/*.pps: No such file or directory
grep: gnuplot.data: No such file or directory
```

**TRAP: the `-d` directory name must not contain `bench` + any character.**
`bench-lab-ministat.sh:73` builds its output name with

```sh
MINISTAT_FILE=$(echo ${INFO} | sed "s/.info//" | sed "s/bench.//")
```

Both patterns are unanchored with an **unescaped `.`** (matches any char) and
run against the *full path*. So a results dir like `/tmp/benchs.D58901` has
`benchs.` stripped out of its own directory name, and the script then tries
to write to a nonexistent `/tmp/.D58901/`:

```
cannot create /tmp/.D58901/bench.n312956.simple_tx_off_default.pps: No such file or directory
```

Plain `/tmp/benchs` is mangled to `/tmp/` too, but harmlessly — which is why
this has never been noticed. Pick a `-d` name with no `bench` substring
(`/tmp/D58901-results`) and it works; that is also cheaper than patching the
sed. Note this collides with the §1 guard that inspects `-d` for filenames
containing `bench`, so keep the directory *name* clean while its *contents*
are the harness's own `bench.*` files.

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

### Pick the comparison baseline by kernel config, not by recency

Before claiming any version delta, find the predecessor that differs in
**one** variable. Newest-on-the-platform is the wrong default: on the APU2,
`fbsd16-n311066.option-RSS.net.isr` is an `option RSS` kernel with
`net.isr.maxthreads=-1`, so a diff against a GENERIC no-RSS run mixes kernel
option *and* netisr tuning and is not a version delta at all. The comparable
set for a GENERIC no-RSS firewall run is `fbsd16-n311215` (same kernel, same
7 config-sets, dualstack).

Check the candidate is actually post-processed before relying on it: some
result dirs (e.g. `fbsd15-n286794.BSDRP.1.992`) are RAW-only, with no
`gnuplot.data`, no README, and a partial config-set list at n=3.

```
ls results/<candidate>/gnuplot.data && cat results/<candidate>/gnuplot.data
```

### Do not generalize a cross-run pattern from 2-3 sets

Survey every set that has a `gnuplot.data` before writing "expected on this
platform". Worked example from 2026-09-21: pf-stateful measured *faster* than
pf-stateless on n313366, and two older sets agreed — but the one directly
comparable predecessor (n311215) did not, and archive-wide it was 3 inverted
vs 2 normal. The real finding was a **+13.9% inet4 / +16.4% inet6 pf-stateful
gain between n311215 and n313366**, with pf-stateless nearly flat; the
inversion was that gain crossing over, not a standing pf property.

```
for d in results/*/; do sf=$(awk '$1=="pf-stateful.inet4"{print $2}' "$d"gnuplot.data 2>/dev/null); \
  sl=$(awk '$1=="pf-stateless.inet4"{print $2}' "$d"gnuplot.data 2>/dev/null); \
  [ -n "$sf" ] && echo "$d $sf $sl"; done
```

Also flag confounds rather than burying them: n311215 predates the e1000 UDP
RSS hashtype fix (D58513), so part of a forwarding-rate gain measured against
it may be that fix rather than the version bump.

## 7. Do not commit

Per repo CLAUDE.md: never `git commit`/`push` unless the user asks.
Leave the new files staged-or-untracked and state what was produced.

## Environment note

This repo runs claude via the FreeBSD linuxlator. `mkdir`/Write on
`/usr/home/...` paths can hit `EACCES` (path-mapping quirk); use the
`/home/olivier/...` equivalent instead. Writing to `/tmp` via the Write
tool can also fail — use a Bash heredoc for /tmp files.
