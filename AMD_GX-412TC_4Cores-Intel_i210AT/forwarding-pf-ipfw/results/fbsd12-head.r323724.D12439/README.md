```
x ../fbsd11.1-yandex/forwarding.inet4.pps
+ HEAD120.inet4.pps
* HEAD120D12439.inet4.pps
+--------------------------------------------------------------------------+
|++                                                         *   *        x |
|++                                                         ********   x xx|
|                                                                       |A||
|A|                                                                        |
|                                                            |_A__|        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        730075        738806        734556      734964.2      3292.366
+  10        495853        499834        496560      497141.3     1415.9471
Difference at 95.0% confidence
	-237823 +/- 2571.21
	-32.3584% +/- 0.274786%
	(Student's t, pooled s = 2173.31)
*  10        691125        714426      703487.5      703086.4     8356.6996
Difference at 95.0% confidence
	-31877.8 +/- 8505.21
	-4.33733% +/- 1.15405%
	(Student's t, pooled s = 7189.03)
```

```
x ../fbsd11.1-yandex/forwarding.inet6.pps
+ HEAD120.inet6.pps
* HEAD120D12439.inet6.pps
+--------------------------------------------------------------------------+
|+                                                                       * |
|+                                                                       * |
|+                                                                       * |
|+                                                        x              * |
|+                                                        x              **|
|++                                                     x xx           ****|
|                                                        |A|               |
|A                                                                         |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        702120        712761        709023      708479.5     3919.0839
+  10        490039      492940.5      490692.5        490898     813.06116
Difference at 95.0% confidence
	-217582 +/- 2693.58
	-30.7111% +/- 0.275736%
	(Student's t, pooled s = 2276.75)
*  10      757768.5        769699      767084.5      766178.4     3437.8562
Difference at 95.0% confidence
	57698.9 +/- 4250.57
	8.14405% +/- 0.618294%
	(Student's t, pooled s = 3592.8)
```

Flamegraph:
  -[FreeBSD -head inet4](bench.HEAD120.inet4.1.pmc.svg)
  -[FreeBSD -head inet6](bench.HEAD120.inet6.1.pmc.svg)
  -[FreeBSD -head with D12439 inet4](bench.HEAD120D12439.inet4.1.pmc.svg)
  -[FreeBSD -head with D12439 inet6](bench.HEAD120D12439.inet6.1.pmc.svg)

