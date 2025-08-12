inet4:
```
x r325006: inet4 packets-per-second
+ r325006 with D12685: inet4 packets-per-second
+--------------------------------------------------------------------------+
|  x x                 x    x                   + +       x        +    ++ |
||_____________________A______________________|                            |
|                                                 |___________A____M______||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        533769        546839      538652.5      538631.2     5283.2651
+   5      544503.5        550422        548852      547726.8     2850.0441
Difference at 95.0% confidence
	9095.6 +/- 6190.71
	1.68865% +/- 1.1644%
	(Student's t, pooled s = 4244.74)
```

inet6:
```
x r325006:inet6 packets-per-second
+ r325006 with D12685: inet6 packets-per-second
+--------------------------------------------------------------------------+
|       x  *   *            +        x   +       +                        x|
||_____________M_____________A__________________________|                  |
|            |______________MA_______________|                             |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        433603        438510        434100      435151.8      2056.723
+   5        433856        436658        435092      435163.6      1207.954
No difference proven at 95.0% confidence
```

Flamegraph:
  -[FreeBSD -head inet4](bench.325006.inet4.1.pmc.svg)
  -[FreeBSD -head inet6](bench.325006.inet6.1.pmc.svg)
  -[FreeBSD -head with D12685 inet4](bench.325006D12685.inet4.1.pmc.svg)
  -[FreeBSD -head with D12685 inet6](bench.325006D12685.inet6.1.pmc.svg)

