Comparing D27401 (Diff 80345) impact on forwarding performance:
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 13-head r368287
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - 2 static routes
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

IPv4:
```
x r368287: IPv4 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x   xx x  x                                                  +   + +    ++|
| |___A___|                                                                |
|                                                               |___MA____||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        704138        712359        708175      708346.6     3032.1925
+   5      754138.5      763692.5        758654      759381.9     3958.0105
Difference at 95.0% confidence
	51035.3 +/- 5141.92
	7.20485% +/- 0.745675%
	(Student's t, pooled s = 3525.62)
```

=> D27401(Diff 80345) brings an improvement of 7.2% to forward IPv4 :-)

IPv6:
```
x r368287: IPv6 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+ ++ ++                                                           xxx x  x|
|                                                                  |_MA_|  |
| |_A_|                                                                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        796553        804471        798560      799697.4     3052.1223
+   5        724301      730460.5        728102      727776.3     2456.4241
Difference at 95.0% confidence
	-71921.1 +/- 4040.37
	-8.99354% +/- 0.478176%
	(Student's t, pooled s = 2770.33)
```

=> D27401(Diff 80345) brings a reduction of 8.9% to forward IPv6 :-(

Just for information, difference with IPv4 and IPv6 forwarding speed:

Without D27401:
```
x r368287: IPv4 packets-per-second forwarded
+ r368287: IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x xxx x                                                            ++++  +|
| |_A_|                                                                    |
|                                                                   |_MA_| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        704138        712359        708175      708346.6     3032.1925
+   5        796553        804471        798560      799697.4     3052.1223
Difference at 95.0% confidence
	91350.8 +/- 4436.84
	12.8963% +/- 0.667712%
	(Student's t, pooled s = 3042.17)
```

=> forwarding IPv6 was 12.9% faster than IPv4

With D27401:
```
x r368287 with D27401(Diff 80345): IPv4 packets-per-second forwarded
+ r368287 with D27401(Diff 80345): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+   +  +  ++                                           x      x x       xx|
|                                                          |_____MA______| |
|  |___AM___|                                                              |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      754138.5      763692.5        758654      759381.9     3958.0105
+   5        724301      730460.5        728102      727776.3     2456.4241
Difference at 95.0% confidence
	-31605.6 +/- 4804
	-4.16202% +/- 0.613725%
	(Student's t, pooled s = 3293.92)
```

=> With D27401, forwarding IPv6 is now 4% slower than IPv4
