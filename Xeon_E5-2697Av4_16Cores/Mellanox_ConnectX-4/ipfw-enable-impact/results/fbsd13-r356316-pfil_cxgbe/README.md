Measuring impact of ipfw-at-nic-level vs ipfw-standard when NO traffic is matched:

```
x forwarding.pps
+ ipfw-standard.pps
* ipfw-at-nic-level.pps
+--------------------------------------------------------------------------+
| *             +                                                          |
|**             +                                                        x |
|**           +++                                                     x xxx|
|                                                                      |AM||
|             |AM                                                          |
||A                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      27117710      27466163      27380606      27333375     134014.19
+   5      22456680      22636389      22609686      22574309     77596.007
Difference at 95.0% confidence
	-4.75907e+06 +/- 159701
	-17.4112% +/- 0.509996%
	(Student's t, pooled s = 109501)
*   5      21392480      21516145      21474405      21459942     50738.072
Difference at 95.0% confidence
	-5.87343e+06 +/- 147779
	-21.4881% +/- 0.440725%
	(Student's t, pooled s = 101327)
```
