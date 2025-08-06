IPv4:

```
x ../fbsd11.1-yandex/forwarding.inet4.pps
+ HEAD120.inet4.pps
* HEAD120D12439.inet4.pps
+--------------------------------------------------------------------------+
|                        *                                                 |
|                        *                                                 |
|+  ++++               * **                                            x xx|
|                                                                       |A||
| |__A_|                                                                   |
|                       |A|                                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1228781     1241890.5       1236356     1235922.2     4678.2161
+   5        907013        933452      925715.5      923289.7     10348.707
Difference at 95.0% confidence
	-312632 +/- 11712.2
	-25.2955% +/- 0.911425%
	(Student's t, pooled s = 8030.61)
*   5       1008438       1021514       1017046     1016324.4     4941.3509
Difference at 95.0% confidence
	-219598 +/- 7017.42
	-17.7679% +/- 0.522536%
	(Student's t, pooled s = 4811.58)
```

IPv6:
```
x ../fbsd11.1-yandex/forwarding.inet6.pps
+ HEAD120.inet6.pps
* HEAD120D12439.inet6.pps
+--------------------------------------------------------------------------+
|++                           *                                           x|
|+++                        ****                                       xxxx|
|                                                                      |_A||
||A|                                                                       |
|                           |_A|                                           |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1084209       1094998       1089761     1090140.4     4386.3543
+   5        828828        836796        830343      831495.6      3097.176
Difference at 95.0% confidence
	-258645 +/- 5537.53
	-23.7258% +/- 0.431297%
	(Student's t, pooled s = 3796.88)
*   5        926382        938427        934456      932737.8     4646.4332
Difference at 95.0% confidence
	-157403 +/- 6589.63
	-14.4387% +/- 0.565029%
	(Student's t, pooled s = 4518.27)
```

Flamegraph:
  -[FreeBSD -head inet4](bench.HEAD120.inet4.1.pmc.svg)
  -[FreeBSD -head inet6](bench.HEAD120.inet6.1.pmc.svg)
  -[FreeBSD -head with D12439 inet4](bench.HEAD120D12439.inet4.1.pmc.svg)
  -[FreeBSD -head with D12439 inet6](bench.HEAD120D12439.inet6.1.pmc.svg)

