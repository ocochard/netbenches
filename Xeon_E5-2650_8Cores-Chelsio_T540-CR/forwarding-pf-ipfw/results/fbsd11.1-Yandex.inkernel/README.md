```
x FreeBSD 11.1-yandex, with cxgbe drivers as module (default): inet4 pps
+ FreeBSD 11.1-yandex, with cxgbe drivers in kernel: inet4 pps
+--------------------------------------------------------------------------+
|+                                                                         |
|+  ++  +                                                         x x x  xx|
|                                                                  |__A___||
||__A__|                                                                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      10917371      10970686      10945136      10946743     22298.313
+   5      10508665      10555035      10529622      10528240     19035.503
Difference at 95.0% confidence
	-418504 +/- 30235.3
	-3.82309% +/- 0.270145%
	(Student's t, pooled s = 20731.2)
```
