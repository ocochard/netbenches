Impact of number of increasing default RX queues on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)

```
x 8 RX queues (default): Number of inet4 packets-per-second forwarded
+ 16 RX queues: Number of inet4 pps forwarded
* 32 RX queues: Number of inet4 pps forwarded
+--------------------------------------------------------------------------+
|x                 +                                                      *|
|xx               ++                                                     **|
|xx               ++                                                     **|
|A|                                                                        |
|                 |A                                                       |
|                                                                        AM|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       8160234       8261012       8230285     8221687.8       42278.4
+   5      10787172      10913225      10820346      10830279     49477.458
Difference at 95.0% confidence
        2.60859e+06 +/- 67115.9
        31.7282% +/- 0.934431%
        (Student's t, pooled s = 46018.9)
*   5      19034716      19176514      19107114      19097753     56388.197
Difference at 95.0% confidence
        1.08761e+07 +/- 72681.8
        132.285% +/- 1.42045%
        (Student's t, pooled s = 49835.2)
```
