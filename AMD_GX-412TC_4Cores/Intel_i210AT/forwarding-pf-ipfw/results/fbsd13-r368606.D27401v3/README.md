Comparing D27401 (Diff 80654) impact on forwarding performance:
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 13-head r368606
  - BUG: 200 flows only of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - 2 static routes
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

IPv4:
```
x r368606: IPv4 packets-per-second forwarded
+ r368606 with D27401(Diff 80654): IPv4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x   x       x x  x                                    +   +       +  +   +|
|  |______A__M___|                                                         |
|                                                        |_______A_M_____| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        693659        700880        698804      697673.4     3029.3716
+   5        717041      725241.5        722101      721296.6     3389.6496
Difference at 95.0% confidence
	23623.2 +/- 4688.25
	3.386% +/- 0.682181%
	(Student's t, pooled s = 3214.56)
```

=> D27401(Diff 80654) brings an improvement of 3.39% to forward IPv4: the improvement
was 7.2% with previous Diff 80345.

IPv6:
```
x r368606: IPv6 packets-per-second forwarded
+ r368606 with D27401(Diff 80654): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|++ ++  +                                                        xx x    xx|
|                                                                |__MA___| |
||__A__|                                                                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        826263        833900        828862      829970.2     3436.7968
+   5        773083        779170        775600      775516.6     2397.9712
Difference at 95.0% confidence
	-54453.6 +/- 4321.75
	-6.56091% +/- 0.497992%
	(Student's t, pooled s = 2963.26)
```

=> D27401(Diff 80654) brings a reduction of 6.5% to forward IPv6:
the reduction with previous Diff 80345 was of 8.9%.

Just for information, difference with IPv4 and IPv6 forwarding speed:

Without D27401:
```
x r368606: IPv4 packets-per-second forwarded
+ r368606: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|   x                                                                  +  +|
|xx xx                                                                ++  +|
| |AM|                                                                     |
|                                                                     |MA_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        693659        700880        698804      697673.4     3029.3716
+   5        826263        833900        828862      829970.2     3436.7968
Difference at 95.0% confidence
	132297 +/- 4724.62
	18.9626% +/- 0.736105%
	(Student's t, pooled s = 3239.5)
```

=> forwarding IPv6 is 18.9% faster than IPv4

With D27401:
```
x r368606 with D27401: IPv4 packets-per-second forwarded
+ r368606 with D27401: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                     +    |
|x x   x x x                                                       ++ +   +|
| |___AM__|                                                                |
|                                                                  |__A__| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        717041      725241.5        722101      721296.6     3389.6496
+   5        773083        779170        775600      775516.6     2397.9712
Difference at 95.0% confidence
	54220 +/- 4281.96
	7.51702% +/- 0.623743%
	(Student's t, pooled s = 2935.98)
```
=> With D27401, forwarding IPv6 is now 7.5% faster than than IPv4
