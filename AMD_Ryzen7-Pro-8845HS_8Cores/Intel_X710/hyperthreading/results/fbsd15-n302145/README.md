# Impact of thriflib.tx_abdicate on forwarding performance

Lab:
  - [Aoostar WTR MAX (8 cores x 2 threads AMD Ryzen 7 PRO 8845HS at 3.8GHz)](https://aoostar.com/products/aoostar-wtr-max-amd-r7-pro-8845hs-11-bays-mini-pc)
  - Intel X710
  - FreeBSD 15-head n302145 (e69573bc2be)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - dev.ixl.X.iflib.tx_abdicate=1

Testing:

- Disable Intel HTT logical CPUs:  machdep.hyperthreading_allowed
- Allow interrupts on HTT logical CPUs:  machdep.hyperthreading_intr_allowed
- Try to make use of logical cores for TX and RX: dev.ixl.X.iflib.use_logical_cores

# Results

## ministat

Unit: packets-per-second forwarded

```
x hyperthreading_allowed=0
+ hyperthreading_allowed=1 and hyperthreading_intr_allowed=0 (default)
* hyperthreading_allowed=1, hyperthreading_intr_allowed=0, use_logical_cores=1
% hyperthreading_allowed=1, hyperthreading_intr_allowed=1
# hyperthreading_allowed=1, hyperthreading_intr_allowed=1, use_logical_cores=1
+--------------------------------------------------------------------------+
|    #                                                      x  *           |
|#  ###%                                                    xx**    *+    *|
|                                                           MA|            |
|                                                             |M_A__|      |
|                                                            |_M__A____|   |
| |__A_|                                                                   |
| |_AM|                                                                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11887346      11944768      11902661      11911258      23826.61
+   5      11944406      12120019      11962549      12013725     81572.087
Difference at 95.0% confidence
	102467 +/- 87638.4
	0.860257% +/- 0.736261%
	(Student's t, pooled s = 60090.4)
*   5      11950922      12232698      11973052      12041179     119317.07
Difference at 95.0% confidence
	129921 +/- 125478
	1.09074% +/- 1.05388%
	(Student's t, pooled s = 86035.7)
%   5      10476784      10632284      10565994      10561775     55433.171
Difference at 95.0% confidence
	-1.34948e+06 +/- 62223.9
	-11.3295% +/- 0.513616%
	(Student's t, pooled s = 42664.6)
#   5      10479587      10595174      10562220      10551319     44032.098
Difference at 95.0% confidence
	-1.35994e+06 +/- 51631.1
	-11.4173% +/- 0.422763%
	(Student's t, pooled s = 35401.5)
```

Impact of machdep.hyperthreading_intr_allowed:

```
x ht_on_intr_off_default.pps
+ ht_on_intr_on.pps
+--------------------------------------------------------------------------+
|    +                                                                     |
|    +                                                             x       |
|+   +  +                                                         xx    x x|
|                                                                 |M_A___| |
| |__A_|                                                                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11944406      12120019      11962549      12013725     81572.087
+   5      10476784      10632284      10565994      10561775     55433.171
Difference at 95.0% confidence
	-1.45195e+06 +/- 101709
	-12.0858% +/- 0.778068%
	(Student's t, pooled s = 69738.2)
```

Impact of iflib.use_logical_cores:

```
x ht_on_intr_off_default.pps
+ ht_on_intr_off_iflib_use_logical_cores.pps
+--------------------------------------------------------------------------+
|     x + x* +                         *        x                         +|
|  |_______M___________A__________________|                                |
||___________M_______________A___________________________|                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11944406      12120019      11962549      12013725     81572.087
+   5      11950922      12232698      11973052      12041179     119317.07
No difference proven at 95.0% confidence
```
