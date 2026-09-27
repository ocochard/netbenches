# 10G WireGuard bench lab configuration

Configuration of the lab nodes that `bench-lab.sh` does **not** drive.

The harness uploads and reboots only the DUT (`configs.kernel/<set>/`).
The packet generator and the WireGuard peer are set up once by hand, so their
configuration is archived here.

`../bench-lab-3nodes.equilibrium.config` holds the full diagram, the MAC
addresses and the pkt-gen command line.

## Nodes

| Role | Host | Mgmt IP | Hardware |
|---|---|---|---|
| Packet generator and receiver | sm2 | 192.168.100.46 | Supermicro, Atom C2758 8 cores, Intel X520 82599ES |
| Device under test | sm1 | 192.168.100.4 | Supermicro, Atom C2758 8 cores, Chelsio T540-CR |
| WireGuard peer | bigone | 192.168.100.2 | AMD EPYC 7502P, 64 threads, Intel X520 |

## The nodes are not directly cabled

All three attach to `switch10g` (192.168.100.252, admin/admin, read-only
inspection with `show vlan`, `show interface ethernet status` and
`show mac-address-table`). The switch segregates them into two VLANs, and
each host has exactly one 10G port on each:

One VLAN per hop, so that every interface carries a single direction:

| VLAN | Name | Ports | Carries |
|---|---|---|---|
| 2 | sender | 1/0/5 sm2 ix1 -> 1/0/7 sm1 cxl1 | clear, offered load |
| 3 | receiver | 1/0/8 sm1 cxl0 -> 1/0/4 bigone ix0 | encrypted |
| 4 | forwarded | 1/0/3 bigone ix1 -> 1/0/6 sm2 ix0 | clear, decrypted |

This three-VLAN grouping was applied for this bench (the switch previously
had two VLANs of three ports each, which forces some interface to carry both
directions: with one port per host per VLAN, the generator->DUT and
peer->receiver hops both terminate on sm2 and therefore want the same VLAN,
while sm2's two ports are necessarily on different ones). No recabling was
needed, only `switchport access vlan` on two ports plus creating VLAN 4.
The port descriptions were corrected at the same time; they previously
labelled sm1's two ports as `sm2-*`.

One trap when mapping this fabric: a switch port reads DOWN while the host
NIC is administratively down, which makes a cabled host look absent.
`ifconfig cxl0 up` on sm1 is what brings 1/0/7 and 1/0/8 up. Confirm port
membership from `show mac-address-table`, not from the descriptions.

## Why bigone is not driven by the harness

`bench-lab.sh` uploads to and reboots `REF_ADMIN` only when a configuration
set contains both a `dut/` and a `refendpoint/` directory. The sets of this
bench hold `boot/` and `etc/` directly, with neither subdirectory, so the
harness takes the single-node branch and never touches bigone.

Note the sets must NOT be shaped as `dut/` alone: the harness would then scp
that directory into `/` and create `/dut` instead of populating `/etc` and
`/boot`, and the upload fails.

That is deliberate for two reasons: bigone is not nanobsd (it has no `/cfg`
and no `config save`, so an uploaded configuration would not persist the way
the harness assumes), and it is a workstation that must not be rebooted
between configuration sets.

`REF_ADMIN` is still set in the bench configuration so that the startup
reachability and ssh-key checks cover bigone; those are read-only.

## Applying these by hand

On sm2, `generator/etc/rc.conf` is a complete file. On bigone,
`refendpoint/etc/rc.conf.fragment` holds only the lines belonging to this
bench, to be merged into its own `/etc/rc.conf`, plus
`refendpoint/etc/wg0.conf` to be installed and applied with:

```sh
wg setconf wg0 /etc/wg0.conf
```

`if_wg(4)` on FreeBSD 16 takes its key and peer from `wg(8)` only;
`ifconfig wg0 create private-key ...` fails with `private-key: bad value`.
The DUT does the same thing from `/etc/rc.local`.

## Things that silently break this bench

- **VLAN 3 carries two streams.** The encrypted stream sm1 -> bigone and the
  decrypted return bigone -> sm2 share that segment, so the measurable
  forwarding rate is capped near 5 Gb/s. At the 711 Mb/s this bench reached
  on FreeBSD 13 that is ample headroom, but a result sitting near 5 Gb/s
  means the segment, not the DUT, is the limit.
- **The generator must not forward** (`gateway_enable="NO"` on sm2). sm2 and
  bigone are both on VLAN 2, so a forwarding generator opens paths the bench
  does not intend.
- **The DUT's route to the receiver prefix must point at the peer's wg0
  address**, not at its physical one. Pointed at the physical address the
  traffic leaves unencrypted on VLAN 3 and the bench silently measures plain
  forwarding.
- **`AllowedIPs` must include the overlay prefixes** on both sides, not just
  the clear ones, or `if_wg` drops the decrypted inner packets.
- **Do not reuse 198.18.0.0/24 or 198.19.0.0/24 on any `igb` port of these
  hosts** while this bench runs. Those prefixes were previously used by the
  gigabit APU2 lab on `igb`, and a leftover connected route there wins over
  the 10G one: probes then leave via `igb` and never touch the fabric.
