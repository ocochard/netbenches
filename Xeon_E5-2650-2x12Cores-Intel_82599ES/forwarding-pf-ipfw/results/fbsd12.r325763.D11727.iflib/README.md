I'm using a fresh head (r325763) and the latest diff (35190) of this review.
on a Dual CPU, Xeon_E5-2650 (12Cores), with Intel 82599ES 10Gigabit (using default 8 queues):

```
x 325763.pps
+ 325763D11727.pps
+--------------------------------------------------------------------------+
|++ ++ +                                                              x xxx|
|                                                                      |AM||
| |_A_|                                                                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4916319       5003793       4989624       4976294     36329.238
+   5       3244804       3392974       3312977     3314548.8     56867.158
Difference at 95.0% confidence
	-1.66175e+06 +/- 69591.5
	-33.3932% +/- 1.28076%
	(Student's t, pooled s = 47716.3)
```
