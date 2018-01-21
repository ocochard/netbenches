
Diff between tunned inet4 vs inet6:

```
x forwarding.inet4.pps
+ forwarding.inet6.pps
+--------------------------------------------------------------------------+
|                                                                  +       |
|                                                                x ++      |
|xx                                                             xx ++      |
|    |_________________________________A________________________M_________||
|                                                                  A|      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      12400863      12454805      12453778      12433028     29107.649
+   5      12455925      12457154      12456589      12456577     580.24418
No difference proven at 95.0% confidence
```

Diff between generic untuned 11.1 vs tunned&yandex patched 11.1

```
x ../../../kern.random.harvest.mask/results/fbsd11.1/511-default.pps
+ forwarding.inet4.pps
+--------------------------------------------------------------------------+
|x                                                                        +|
|x                                                                       ++|
|xxx                                                                     ++|
|MA                                                                        |
|                                                                        |A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4784586       4955119     4829581.5     4862892.3     74480.616
+   5      12400863      12454805      12453778      12433028     29107.649
Difference at 95.0% confidence
	7.57014e+06 +/- 82467.3
	155.671% +/- 4.08527%
	(Student's t, pooled s = 56544.7)
```
