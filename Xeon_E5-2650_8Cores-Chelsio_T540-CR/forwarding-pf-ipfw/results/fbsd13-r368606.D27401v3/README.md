Comparing D27401 (Diff 80654) impact on forwarding performance:
  - HP ProLiant DL360p Gen8 with 8 cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 13-head r368606
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled

IPv4:
```
x r368606: inet packets-per-second forwarded
+ r368606 with D27401 (Diff 80654): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+       +     +         +          +  x        x         x               x|
|                                          |___________A__M_________|      |
|  |___________M_A_____________|                                           |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14817212      14817568      14817398      14817376     133.04435
+   5      14816815      14817177      14816960      14816983     142.31479
Difference at 95.0% confidence
	-393.4 +/- 200.911
	-0.00265499% +/- 0.0013559%
	(Student's t, pooled s = 137.758)
```

IPv6:
```
x r368606: inet6 packets-per-second forwarded
+ r368606 with D27401 (Diff 80654): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|   + ++  +           x       +          xx     x                         x|
|                          |______________M__A__________________|          |
||_____M___A__________|                                                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14472495      14472837      14472627      14472649     123.29315
+   5      14472380      14472548      14472400      14472427     68.700073
Difference at 95.0% confidence
	-222 +/- 145.556
	-0.00153393% +/- 0.00100572%
	(Student's t, pooled s = 99.8021)
```

Flamegraphs:
- [r368287: inet4](bench.r368606.inet4.pmc.svg)
- [r368287: inet6](bench.r368606.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368606D27401v3.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368606D27401v3.inet6.pmc.svg)

But I never saw a 14.8Mpps forwarding speed on this hardware before,
let's compare with previous benches:

IPv4:
```
x r368287: inet packets-per-second forwarded
+ r368606: inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|    x                                                                    +|
|    x                                                                    +|
|x  xx                                                                    +|
| |_AM                                                                     |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9658584       9920131       9909120     9860697.6     113143.24
+   5      14817212      14817568      14817398      14817376     133.04435
Difference at 95.0% confidence
	4.95668e+06 +/- 116682
	50.267% +/- 1.77811%
	(Student's t, pooled s = 80004.4)
```

IPv6:
```
x r368287: inet6 packets-per-second forwarded
+ r368606: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|                                                                         +|
|   x                                                                     +|
|x xxx                                                                    +|
| |AM|                                                                     |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      12231886      12345704      12320352      12308620     45558.438
+   5      14472495      14472837      14472627      14472649     123.29315
Difference at 95.0% confidence
	2.16403e+06 +/- 46983.4
	17.5814% +/- 0.448821%
	(Student's t, pooled s = 32214.8)
```

=> 50% improvement between r368287 and r368606 regarding inet forwarding speed!
=> 17% imprevent on inet6
=> Reaching line-rate now (14.8Mpps) !
