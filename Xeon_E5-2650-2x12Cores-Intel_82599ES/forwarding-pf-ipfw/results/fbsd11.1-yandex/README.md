Comparing fbsd 11.1-generic vs 11.1-yandex
- kern.random.harvest.mask=351


```
x ../../../kern.random.harvest.mask/results/fbsd11.1/351.pps
+ bench.pps
+--------------------------------------------------------------------------+
|                                                                     +    |
|xx   xxx                                                        +    +  ++|
| |__AM_|                                                                  |
|                                                                  |__A___||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3572227       3857446       3779575     3733768.8     125050.81
+   5       6253920       6630136       6464476     6480984.4      148771.8
Difference at 95.0% confidence
	2.74722e+06 +/- 200425
	73.5775% +/- 7.26827%
	(Student's t, pooled s = 137424)
```
