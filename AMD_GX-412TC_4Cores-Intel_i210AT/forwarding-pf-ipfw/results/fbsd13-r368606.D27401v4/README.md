Comparing D27401 (Diff 80677) impact on forwarding performance:
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 13-head r368606
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - 2 static routes
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

IPv4:
```
x r368606: IPv4 packets-per-second forwarded
+ r368606 with D27401(Diff 80677): IPv4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|xxx x                                                             + +++  +|
||MA|                                                                      |
|                                                                   |_A__| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        694169        700644        696703      696971.6     2341.4822
+   5        813395        825061      818114.5      818684.2     4337.6171
Difference at 95.0% confidence
	121713 +/- 5083.41
	17.4631% +/- 0.759963%
	(Student's t, pooled s = 3485.5)
```

=> D27401(Diff 80677) brings an improvement of 17.5% to forward IPv4!

IPv6:
```
x r368606: IPv6 packets-per-second forwarded
+ r368606 with D27401(Diff 80677): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|    +                                                               x     |
|+++ +                                                     x        xx    x|
|                                                             |_____AM___| |
||_A_|                                                                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        824195        838004        833084      832263.4      5003.562
+   5        770041        773742        771634      771993.2     1539.7236
Difference at 95.0% confidence
	-60270.2 +/- 5398.84
	-7.24172% +/- 0.605924%
	(Student's t, pooled s = 3701.78)
```

=> D27401(Diff 80677) brings a reduction of 7.2% to forward IPv6:

Just for information, difference with IPv4 and IPv6 forwarding speed:

Without D27401:

```
x r368606: IPv4 packets-per-second forwarded
+ r368606: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
| x                                                                     +  |
|xx x                                                              +   ++ +|
||A_|                                                                      |
|                                                                    |_AM_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        694169        700644        696703      696971.6     2341.4822
+   5        824195        838004        833084      832263.4      5003.562
Difference at 95.0% confidence
	135292 +/- 5697.1
	19.4114% +/- 0.848102%
	(Student's t, pooled s = 3906.29)
```

=> forwarding IPv6 is 19.4% faster than IPv4

With D27401:

```
x r368606 with D27401: IPv4 packets-per-second forwarded
+ r368606 with D27401: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|  +                                                                       |
|+ + ++                                                    x   x x  x     x|
|                                                           |____MA____|   |
| |MA_|                                                                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        813395        825061      818114.5      818684.2     4337.6171
+   5        770041        773742        771634      771993.2     1539.7236
Difference at 95.0% confidence
	-46691 +/- 4746.74
	-5.70318% +/- 0.550533%
	(Student's t, pooled s = 3254.66)
```

=> With D27401, forwarding IPv6 is now 'only' 5.7% faster than than IPv4
   (inet4 speed improved and inet6 reduced)
