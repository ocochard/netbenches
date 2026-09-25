# OpenVPN bench lab configuration

The packet generator and receiver (sm1) is not driven by `bench-lab.sh`: the
harness only uploads to the DUT and to the reference endpoint. Its
configuration is archived once, under the ipsec bench of this same machine,
and this bench reuses it unchanged:

  ../../ipsec/lab/generator/

Both benches use the same three nodes and the same lab addressing, so keeping
one copy avoids the two drifting apart. `../bench-lab-3nodes.config` holds the
topology diagram and the MAC addresses for this bench.

## Nodes

| Role | Host | Mgmt IP | Hardware |
|---|---|---|---|
| Packet generator and receiver | sm1 | 192.168.100.4 | Supermicro, Intel Atom C2758 |
| Device under test | apu2-3 | 192.168.100.43 | PC Engines APU2, AMD GX-412TC 4 cores |
| OpenVPN server endpoint | sm2 | 192.168.100.46 | Supermicro, Intel Atom C2758 |

## What differs from the ipsec bench

- The DUT is the OpenVPN **client**, sm2 the **server**, tunnel on UDP/1194
  between 198.18.1.205 and 198.18.1.203.
- The route to 198.19.0.0/16 is **pushed by the server** through the tunnel,
  so the DUT must not have a static one: a leftover static route sends the
  traffic straight out igb2 and the bench measures plain forwarding.
- `IS_DUT_ONLINE_CMD` pings directly connected addresses only. `reboot_host()`
  runs it on the DUT, so a ping crossing the tunnel would make the reboot wait
  depend on the tunnel coming back and fail on a false timeout. The tunnel is
  checked by `BEFORE_CMD` instead, once per bench, output kept in
  `RAW/*.before`.
- The client configurations carry `resolv-retry infinite`, `persist-key`,
  `persist-tun` and `connect-retry 1 10`: the harness reboots the server before
  every configuration set, and without these the client gives up and the next
  bench measures nothing.
