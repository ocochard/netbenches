# Impact of iflib `simple_tx` on APU2 forwarding performance

Does enabling the iflib `simple_tx` ("use simple tx ring") tunable change
IPv4/IPv6 packet forwarding throughput on a low-end multi-queue Intel igb
NIC?

## Hardware

- PC Engines APU2 (DUT: `apu2-2`)
- CPU: AMD GX-412TC SOC, 4 cores @ ~1 GHz (K8-class)
- NIC: 3x Intel i210AT (igb), traffic on igb1 (in) / igb2 (out)

## Software

- FreeBSD 16.0-CURRENT (BSDRP, image label `fbsd16-n311215`)
- fastforwarding enabled (ICMP redirect disabled)
- Ethernet flow control disabled on all igb ports

## What `simple_tx` does

`dev.igb.<n>.iflib.simple_tx` selects iflib's "simple tx ring" transmit
path. Unlike `tx_abdicate`, this knob is a **read-only tunable**
(`CTLFLAG_RDTUN` in `sys/net/iflib.c`): it is read once at driver attach
and cannot be changed at runtime, so it must be set in
`boot/loader.conf.local`, not `sysctl.conf`. The bench measures the
forwarding cost of that alternate TX path.

## Bench

- pkt-gen (netmap) minimum-size UDP frames, 2000 flows (`dualstack-2k`)
- 5 iterations per data point, DUT rebooted between every run
- Two config sets, identical except for the tunable:
  - `simple_tx_off_default`: driver default (tunable unset)
  - `simple_tx_on`: `dev.igb.0/1/2.iflib.simple_tx="1"` in loader.conf.local

The `simple_tx=1` tunable was confirmed applied on the live DUT after
boot (`dev.igb.0/1/2.iflib.simple_tx: 1`).

## Result

![Impact of simple_tx on APU2 forwarding](graph.png)

Median pps (5 iterations):

| config | inet4 | inet6 |
|-----------------------|-----------|-----------|
| simple_tx off (default) | 883,374 | 871,344 |
| simple_tx on            | 379,926 | 356,360 |

**Enabling `simple_tx` is a large regression on this platform: forwarding
throughput drops ~57% (IPv4) / ~59% (IPv6), a factor of ~2.3x slower.**
The effect is highly significant and well outside the run-to-run noise
band. On this APU2 / i210 the simple tx ring should stay disabled.

### ministat, IPv4 (off vs on)

```
x simple_tx_off_default.inet4.pps
+ simple_tx_on.inet4.pps
+--------------------------------------------------------------------------+
|+                                                                         |
|++                                                                      x |
|++                                                                 x   xxx|
|MA                                                                   |_AM||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        851176        890326        883374      877643.6     15603.947
+   5      376570.5        384448        379926      380354.2     2824.2224
Difference at 95.0% confidence
	-497289 +/- 16353.4
	-56.6619% +/- 0.861136%
	(Student's t, pooled s = 11212.9)
```

### ministat, IPv6 (off vs on)

```
x simple_tx_off_default.inet6.pps
+ simple_tx_on.inet6.pps
+--------------------------------------------------------------------------+
| +                                                                      x |
| +                                                                      x |
|+++                                                                   x xx|
||A|                                                                   |_A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        851685      874740.5        871344      867461.9      9118.495
+   5      347884.5        363561        356360      356020.2     5561.7962
Difference at 95.0% confidence
	-511442 +/- 11014.9
	-58.9584% +/- 0.796958%
	(Student's t, pooled s = 7552.5)
```
