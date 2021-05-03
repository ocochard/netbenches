Bisec Mellanox forwarding speed regression:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - RX NIC (heavy work): Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - TX NIC: Mellanox_ConnectX-4
  - Chelsio RX & TX queues to 32
  - FreeBSD 13-head r368606
  - 4000 flows only of smallest UDP packets
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - ICMP redirect disabled

Regression
 - Before: 26.84 Mpps
 - After:  11.83 Mpps

Bisec difficulties because regressions:
  - c255749 (9a47ae044b48): Good performance
    'Bump driver versions for mlx5en(4) and mlx4en(4)'
  - c255755 (6815909abda) : Unknown (Mellanox drivers bug)
    'Move the PMC overflow count to make it per-CPU'
  - c255751 (f8f5b459d21) : Unknown (Melllanox drivers bug)
    'Update user access region, UAR, APIs in the core in mlx5core'
  - c255761 (431980466ff0): Bad performance (and fixed Mellanox drivers)
    'Don't offset the UAR map twice in mlx5en(4)'

Results:

```
x c255749 (9a47ae044b48): inet packets-per-second forwarded
+ c255761 (431980466ff0): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+                                                                         |
|+                                                                         |
|+                                                                         |
|+                                                                       xx|
|+                                                                      xxx|
|                                                                        A||
|A                                                                         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      26616402      26971182      26860046      26842439     141437.64
+   5      11825044      11841625      11838471      11834989     6869.5818
Difference at 95.0% confidence
	-1.50075e+07 +/- 146033
	-55.9094% +/- 0.241036%
	(Student's t, pooled s = 100129)x r368606: inet6 packets-per-second forwarded
```

Flamegraphs:
- [c255749](bench.9a47ae044b48.1.pmc.svg)
- [c255761](bench.431980466ff0.1.pmc.svg)
