```
x HEAD120Yandex.pps
+ HEAD120YandexVLAN.pps
+--------------------------------------------------------------------------+
|x     x  x                                                  +    + +    ++|
|  |___A___|                                                               |
|                                                              |____A_____||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       8487811     8738861.5       8663164       8656120      100617.1
+   5      10147379      10514220      10359362      10358837      145931.9
Difference at 95.0% confidence
	1.70272e+06 +/- 182800
	19.6707% +/- 2.25403%
	(Student's t, pooled s = 125339)
```

Flamegraph:
   - [FreeBSD 12-head with Yandex's patch](bench.HEAD120Yandex.1.pmc.svg)
   - [FreeBSD 12-head with Yandex's and VLAN patch](bench.HEAD120YandexVLAN.1.pmc.svg)

