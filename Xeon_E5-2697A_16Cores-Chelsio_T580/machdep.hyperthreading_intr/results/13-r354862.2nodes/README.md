Impact of enabling machdep.hyperthreading_intr_allowed on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)
  - Chelsio configured with 32 RX queues

```
x machdep.hyperthreading_intr_allowed=0 (default): Number of inet4 packets-per-second forwarded
+ machdep.hyperthreading_intr_allowed=1: Number of pps
+--------------------------------------------------------------------------+
| x                                                                       +|
| x                                                                       +|
|xx                                                                     +++|
||A                                                                        |
|                                                                        AM|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      19028337      19126428      19099721      19090535     37168.444
+   5      24396932      24508797      24494912      24476810     45506.933
Difference at 95.0% confidence
        5.38628e+06 +/- 60594.5
        28.2144% +/- 0.355956%
        (Student's t, pooled s = 41547.4)
```
