Comparing D27401 (Diff 80677) impact on forwarding performance:
  - HP ProLiant DL360p Gen8 with 8 cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 13-head r368606
  - BUG: 200 flows only of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled

IPv4:
```
x r368606: inet packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+    +   + x      +          +       x        x           x              x|
|                      |______________________AM______________________|    |
| |_______M__A___________|                                                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14817134      14817605      14817404      14817394     177.27183
+   5      14817053      14817274      14817120      14817145     88.039764
Difference at 95.0% confidence
	-249.4 +/- 204.12
	-0.00168316% +/- 0.00137755%
	(Student's t, pooled s = 139.958)
```

IPv6:
```
x r368606: inet6 packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x         +        +        x     +  +    +          x        x          x|
|              |____________________________A_________M___________________||
|               |_____________A____M_______|                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14472227      14472800      14472646      14472567     229.55892
+   5      14472307      14472558      14472490      14472451     104.45908
No difference proven at 95.0% confidence
```

Flamegraphs:
- [r368287: inet4](bench.r368606.inet4.pmc.svg)
- [r368287: inet6](bench.r368606.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368606D27401v4.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368606D27401v4.inet6.pmc.svg)


