Comparing impact of patch D5330 (https://reviews.freebsd.org/D5330) on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 10-stable r295802 with D5330
  - 2000 flows of smallest UDP packets
  - ntxq10g and nrxq10g = 4 (and not the default value of ncpu=8)
  - Traffic load at 10Mpps

Same performance (at 95% confidence) with D5330 and fastforwarding mode:

```
x 10-stable r295802.fastforwarding (pps)
+ 10-stabble r295802 with D5330.fastforwarding (pps)
+--------------------------------------------------------------------------+
|                                         x          x                 +   |
|x   x                       +  +  +    ++xxx x      x*           +    +  +|
|                  |__________________A____M______________|                |
|                                 |_____________M__A_________________|     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10     2108683.5       2553645     2460830.8     2420369.1     160855.67
+  10     2343852.5       2718812     2497405.5     2529979.1     149422.27
No difference proven at 95.0% confidence

```
Forwarding pmc (CPU_CLK_UNHALTED_CORE) gprof files:
  - [10-stable r295802 pmc gprof] (pmcstat-gprof-295802.txt)
  - [10-stable r295802 with D5330 pmc gprof] (pmcstat-gprof-295802D5330.txt)

Little regression (-3.3% +/- 1.5%) with D5330 with ipfw enabled:
```
x 10-stable r295802.ipfw-statefull (pps)
+ 10-stable r295802 with D5330.ipfw-statefull (pps)
+--------------------------------------------------------------------------+
|                            +                x                            |
|+            + ++       +   +  +x          +x* x   x   x     x x         x|
|                                        |________M_A___________|          |
|          |_____________A_M___________|                                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1727219     1816418.5     1764057.5     1769846.9     25310.426
+  10       1659426     1757013.5     1715638.2     1711804.8     29838.242
Difference at 95.0% confidence
        -58042.1 +/- 25995.9
        -3.2795% +/- 1.46882%
        (Student's t, pooled s = 27667.1)
```

Little regression ( -2.8% +/- 1%) with D5330 with pf enabled:
```
x 10-stable r295802.pf-statefull (pps)
+ 10-stable r295802 with D5330.pf-statefull (pps)
+--------------------------------------------------------------------------+
|              +                    x                                      |
|+        ++ +++   +      + x   +  xx  x   x       x         x  x         x|
|                               |________M_____A______________|            |
|      |______M_A_______|                                                  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1652714     1722700.5       1671700     1680835.6     23017.454
+  10       1610751       1659040       1631421     1633238.8     13336.253
Difference at 95.0% confidence
        -47596.8 +/- 17674.1
        -2.83173% +/- 1.05151%
        (Student's t, pooled s = 18810.4)
```
