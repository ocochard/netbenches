Impact of enabling firewalls on BSDRP 1.90 (FreeBSD 11.2-BETA3) forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - FreeBSD 13-head r368606
  - BUG: 200 flows only of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled
  - Traffic load at 14.88 Mpps

IPv4:
```
x r368606: inet packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|x   x       x        xx                                            ++  +++|
|  |_________A________|                                                    |
|                                                                   |__AM_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       5004207       5283305       5163716     5155379.6     124854.46
+   5       5863973       5946368       5924908     5908532.2     35107.223
Difference at 95.0% confidence
	753153 +/- 133753
	14.6091% +/- 2.94733%
	(Student's t, pooled s = 91709.2)
```

=> 14.6% improvement with D27401 (Diff 80677) on inet forwarding performance!

IPv6:
```
x r368606: inet6 packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                             +            |
|x           x    xxx                                +        ++          +|
|     |_______A___M___|                                                    |
|                                                      |______MA______|    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4978494       5139249       5126860     5090932.4     66928.484
+   5       5424518       5605214       5504621     5509425.4     64107.037
Difference at 95.0% confidence
	418493 +/- 95576
	8.22036% +/- 1.95938%
	(Student's t, pooled s = 65532.9)
```

=> 8.2% improvement with D27401 (Diff 80677) on inet6 forwarding performance!

Flamegraphs:
- [r368287: inet4](bench.r368606.inet4.pmc.svg)
- [r368287: inet6](bench.r368606.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368606D27401v4.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368606D27401v4.inet6.pmc.svg)
