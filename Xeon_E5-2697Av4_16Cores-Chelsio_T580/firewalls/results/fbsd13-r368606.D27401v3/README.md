Comparing D27401 (Diff 80654) impact on forwarding performance:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - Increase number of Chelsio RX & TX queues to 32
  - FreeBSD 13-head r368606
  - 5000 flows of smallest UDP packets
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351

IPv4:

```
x r368606: IPv4 packets-per-second forwarded
+ r368606 with D27401(Diff 80654): IPv4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+    + +   +              +          x              x     x   x          x|
|                                           |____________A_M__________|    |
||______M__A_________|                                                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      31950602      31992272      31974666      31972910      15337.67
+   5      31908856      31938428      31917094      31919932     11254.459
Difference at 95.0% confidence
	-52978.6 +/- 19618.8
	-0.165698% +/- 0.0612947%
	(Student's t, pooled s = 13451.9)
```

IPv6:

```
x r368606: IPv6 packets-per-second forwarded
+ r368606 with D27401(Diff 80654): IPv6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+                                    + +           xx  x     + x         +|
|                                                  |_M_A____|              |
|              |________________________M__A___________________________|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      31086077      31087735      31086278      31086587     675.74085
+   5      31078924      31089195      31084426      31084830     3932.8519
No difference proven at 95.0% confidence
```

Flamegraphs:
- [r368287: inet4](bench.r368606.inet4.pmc.svg)
- [r368287: inet6](bench.r368606.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368606D27401v3.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368606D27401v3.inet6.pmc.svg)
