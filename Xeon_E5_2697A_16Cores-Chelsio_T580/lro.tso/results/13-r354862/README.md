Impact of disabling LRO & TSO on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)
  - hw.cxgbe.nrxq="32
  - machdep.hyperthreading_intr_allowed="1"

```
x enabled (default): Number of inet4 packets-per-second forwarded
+ disabled (-tso4 -tso6 -lro -vlanhwtso): Number of inet4 pps forwarded
+--------------------------------------------------------------------------+
|x     x x       x                                                + +   +++|
|  |_____MA______|                                                         |
|                                                                  |__A_M_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      24474825      24514420      24494558      24497564      16705.05
+   5      24636711      24656634      24651352      24648128     8776.9884
Difference at 95.0% confidence
        150564 +/- 19460.6
        0.614609% +/- 0.0798219%
        (Student's t, pooled s = 13343.4)
```
