Comparing benefit of patch [D4306] (https://reviews.freebsd.org/D4306) on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11-head r296935
  - 2 static routing tables
  - 2000 flows of smallest UDP packets
  - ntxq10g and nrxq10g = 4 (and not the default value of ncpu=8)
  - Traffic load at 10Mpps

Same performance (at 95% confidence) with D4306 and forwarding mode:
```
x r296935.forwarding (pps)
+ r296935 with D4306.forwarding (pps)
+--------------------------------------------------------------------------+
|x   +x  ++  +  +x +                x+     +  x+*               xx        x|
|              |________________________A_____M__________________|         |
|       |_________M______A________________|                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10     2678498.5       3143659     2963824.5     2928823.5     160645.28
+  10       2700885       2975589     2784147.2     2829823.4     109114.42

```

About -1.4% performance with pf enabled:
```
x r296935.pf-statefull (pps)
+ r296935 with D4306.pf-statefull (pps)
+--------------------------------------------------------------------------+
|+                                                                         |
|+   ++      +  x  x    + x+ x+    x  x          +  xx +    x             x|
|                    |_______________M__A__________________|               |
| |_______________M__A__________________|                                  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1789761       1871505     1818998.8     1824104.6      26579.58
+  10     1768848.5       1844112     1793202.5     1797013.2     27166.206
Difference at 95.0% confidence
        -27091.3 +/- 25251.2
        -1.48518% +/- 1.3843%
        (Student's t, pooled s = 26874.5)
```

About -2% performance with ipfw enabled:
```
x r296935.ipfw-statefull (pps)
+ r296935 with D4306.ipfw-statefull (pps)
+--------------------------------------------------------------------------+
|+     + +          + *        +    x  + *    *      x        x xx+ x     x|
|                                    |_______________A____M___________|    |
|       |_________________M_A___________________|                          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       2236931       2337380     2305567.5     2297062.2     32138.242
+  10       2195066       2321463     2244308.5     2247927.2     39411.427
Difference at 95.0% confidence
        -49135 +/- 33787.1
        -2.13903% +/- 1.47088%
        (Student's t, pooled s = 35959.2)
```
