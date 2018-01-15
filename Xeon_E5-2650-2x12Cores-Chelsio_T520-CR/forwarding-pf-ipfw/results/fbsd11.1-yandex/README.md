Diff between 11.1-generic and 11.1-yandex
- kern.random.harvest.mask=351

```
x ../../../kern.random.harvest.mask/results/fbsd11.1/351.pps
+ bench.pps
+--------------------------------------------------------------------------+
|xx                                                                    +  +|
|xx x                                                                  + ++|
||A|                                                                       |
|                                                                      |AM||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4841608       5029324       4874023     4895767.2      76485.89
+   5     9435692.5       9655273       9601921     9564303.5     103260.29
Difference at 95.0% confidence
	4.66854e+06 +/- 132521
	95.3586% +/- 3.82597%
	(Student's t, pooled s = 90864.7)
```
