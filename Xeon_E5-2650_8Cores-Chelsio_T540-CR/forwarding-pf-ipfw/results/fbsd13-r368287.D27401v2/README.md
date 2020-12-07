Comparing D27401 (Diff 80345) impact on forwarding performance:
  - HP ProLiant DL360p Gen8 with 8 cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 13-head r368287
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled

IPv4:
```
x r368287: IPv4 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                        + |
|                                                                        + |
|x                                            xxxx               +   +   + |
|                |____________________A________M___________|               |
|                                                                  |__A__M||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9658584       9920131       9909120     9860697.6     113143.24
+   5      10003670      10049670      10047306      10035246     19912.559
Difference at 95.0% confidence
	174548 +/- 118475
	1.77014% +/- 1.22212%
	(Student's t, pooled s = 81233.9)
```

=> D27401(Diff 80345) brings a small improvement of 1.7% to forward IPv4

IPv6:
```
x r368287: IPv6 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x                  x   x    x x                        +     +   +    +  +|
|        |___________A__M________|                                         |
|                                                          |______A______| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      12231886      12345704      12320352      12308620     45558.438
+   5      12441659      12511796      12481834      12480211      27683.06
Difference at 95.0% confidence
	171591 +/- 54976.9
	1.39407% +/- 0.45121%
	(Student's t, pooled s = 37695.6)
```

=> D27401(Diff 80345) brings a small improvement of 1.4% to forward IPv6

Flamegraphs:
- [r368287: inet4](bench.r368287.inet4.pmc.svg)
- [r368287: inet6](bench.r368287.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368287D27401v2.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368287D27401v2.inet6.pmc.svg)

Just for information, difference with IPv4 and IPv6 forwarding speed:

Without D27401:
```
x r368287: IPv4 packets-per-second forwarded
+ r368287: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|       x                                                                ++|
|x      x                                                              + ++|
|  |__A_M_|                                                                |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9658584       9920131       9909120     9860697.6     113143.24
+   5      12231886      12345704      12320352      12308620     45558.438
Difference at 95.0% confidence
	2.44792e+06 +/- 125786
	24.825% +/- 1.552%
	(Student's t, pooled s = 86246.6)
```

=> forwarding IPv6 was 24.8% faster than IPv4

With D27401:

```
x r368287 with D27401(Diff 80345): IPv4 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
| x                                                                      ++|
|xx                                                                     +++|
||A                                                                        |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      10003670      10049670      10047306      10035246     19912.559
+   5      12441659      12511796      12481834      12480211      27683.06
Difference at 95.0% confidence
	2.44497e+06 +/- 35167.2
	24.3638% +/- 0.381702%
	(Student's t, pooled s = 24112.9)
```

=> Same 24% difference with D27401 applied
