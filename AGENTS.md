# AGENTS.md

This file provides guidance to AI tooling when working with code in this repository.

## What this repo is

A results archive plus the harness that produced it: FreeBSD network forwarding / firewalling / VPN performance benchmarks across many hardware platforms (APU2, Netgate C2558, Atom C2758, various Xeon, Ryzen) and NICs (Intel i210/i350/82599/X710, Chelsio T520/T540/T580, Mellanox ConnectX-3/4). Most commits add new result sets rather than change code.

Top-level directories are named `<CPU>_<Cores>Cores/` (e.g. `AMD_GX-412TC_4Cores/`); one level down is `<NIC_model>/` (e.g. `Intel_i210AT/`); below that, one directory per bench topic (`firewalls/`, `ipsec/`, `openvpn/`, `wireguard/`, `pf-states_hashsize/`, `hw.igb.num_queues/`, …).

Inside a bench topic, the layout is fixed:
- `configs/<config-set>/{boot,etc}/…` — files uploaded verbatim onto the DUT's nanobsd config partition before each run
- `results/<image-label>/` — outputs: `gnuplot.data`, `graph.png`, `README.md`, per-config `.data` files, and `RAW/` with the pkt-gen sender/receiver dumps
- Occasionally a local `bench-lab-2nodes.config` overriding the machine-level one

Machine root usually also holds a `bench-lab-*.config` that describes the lab topology (IPs, MACs, interfaces, pkt-gen command). The examples in `AMD_GX-412TC_4Cores/Intel_i210AT/bench-lab-2nodes.config` are the reference — read that file's ASCII diagram before touching lab config elsewhere.

## The harness

Two shell scripts under `scripts/` drive everything; `doc/README.md` is authoritative.

- `scripts/bench-lab.sh` — main runner. Nested loops: nanobsd image → configuration-set → pkt-gen configuration → iteration. At each level it uploads/reboots the DUT via SSH, then runs pkt-gen sender & receiver via SSH on the traffic-generator hosts. All node interaction is SSH; the DUT is assumed to be nanobsd-based (BSDRP) so that a new image can be flashed as an "upgrade" between iterations. `-eu` and heavy use of `die`.
- `scripts/bench-lab-ministat.sh` — post-processor. Reads each `bench.<IMAGE>.<CFG>.<PKTGEN>.<ITER>.receiver` raw file, drops the first 15 / last 10 lines, runs `ministat` to get a median, aggregates to `<config>.pps` (one median per iteration) then to `results/<label>/gnuplot.data` (`#index median minimum maximum`). Requires `ministat(1)` on the host running the script.

Typical invocations (run from the machine's bench-topic dir):

```
../../../scripts/bench-lab.sh \
    -f ../bench-lab-2nodes.config \
    -c configs \
    -p ../../../pktgen.configs/RFC2544 \
    -n 5 \
    -d /tmp/benchs \
    -r you@example.com

../../../scripts/bench-lab-ministat.sh /tmp/benchs
```

Flags accepted by `bench-lab.sh`: `-f` bench config (mandatory), `-c` config-sets dir, `-i` nanobsd images dir, `-n` iterations (min 3, default 5), `-p` pkt-gen configs dir, `-d` results dir (default `/tmp/benchs`), `-r` report email. Extra opt-ins via env: `PMC=true` to collect hwpmc, `STATS=true` for extra stats, `CUSTOM_CMD="…"` to run a command on the DUT during each run, `SENDER_START_CMD_2` / `SENDER_ADMIN_2` when a single generator can't produce the load (see the header comment in `bench-lab.sh` for the 3-node and 4-node topologies).

`pktgen.configs/` holds cross-machine pkt-gen presets (RFC2544 sizes 64…1518, `flows-*`, `dualstack-*`, `inet6-2k`); pass its subdirectory to `-p`. `IP-random-generator/`, `gen_hash_data`, and `gen-*.sh` are helper generators used to build the config-set trees (firewall rules, IPsec/OpenVPN configs, queue counts, hash tables) — regenerate rather than hand-edit large rule files.

## Assembling a new bench

1. Copy the closest existing `configs/` tree; edit `etc/rc.conf`, `etc/sysctl.conf`, `boot/loader.conf.local` per config set. One directory per data point on the final graph.
2. Adjust the machine's `bench-lab-*.config` — IPs, MACs, interface names, `SENDER_START_CMD` — from the layout diagrammed at the top of the reference config.
3. Run `bench-lab.sh` (above). Iterate ≥5 times; the ministat pass drops noisy edges.
4. Run `bench-lab-ministat.sh` on the results dir, then hand-write `results/<label>/gnuplot.plt` and generate `graph.png` with `gnuplot`.
5. Add a `results/<label>/README.md` documenting kernel/image, hardware detail, and observations, and link it from the top-level `README.md` under the matching bench category.

`synthesis/` collects cross-hardware summary plots (`*.plt` → `*.png`) — update these when a new hardware datapoint changes the story.

## Ansible port (WIP)

`ansible/` is an in-progress rewrite of the shell harness. `ansible/README.md` describes goals and current entrypoints (`bench.yml`, `learning_loop.yml`, inventories like `apu2_forwarding`). Roles under `ansible/roles/` map to the shell loops (`loop_firmwares`, `loop_configs`, `loop_pktgens`, `loop_benches`, `bench`, plus per-feature `tuning_*`, `forwarding`, `static_routes`). It is not yet the primary path — the shell scripts are still what produced everything under version control.

## Conventions when adding results

- Result directory names encode the FreeBSD build: `fbsd<major>-<tag>` (e.g. `fbsd14-c276570-BSDRP1.991`, `fbsd15-n302145`). Match the existing pattern for the platform.
- Keep the `RAW/` dumps — the ministat pass depends on them, and they let later revisions of the analysis script rerun without redoing the physical bench.
- The top-level `README.md` is the site map; every non-trivial `results/<label>/README.md` should be linked from it under the correct bench category.
