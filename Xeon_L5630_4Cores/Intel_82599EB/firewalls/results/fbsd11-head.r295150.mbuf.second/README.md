Impact of glebius'mbuf not inlined" patch [D5180] (https://reviews.freebsd.org/D5180) and ipfw/pf on forwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 11 head r295150
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - Traffic load at 14.48Mpps (10Gigabit line-rate)
  - harvest.mask=351

This is the second run of a previous bench: Checking bench methodology for consistent results.
[First run benches results] (../fbsd11-head.r295150.mbuf/README.md)

Synthesis of difference at 95.0% confidence:
  - forwarding: No difference (same as first run)
  - pf impact of forwarding: -1.4% +/- 0.9% (-1.5% +/- 1% on the first run)
  - ipfw impact of forwarding: -3.2% +/- 1% (-3.3% +/- 2.4% on the first run)

On forwarding:

```
x 295150.forwarding
+ 295150mbuf.forwarding
+--------------------------------------------------------------------------------+
|                              +        +                                 x      |
|+                             +        *   +x x      xx   +      +   + + x   xxx|
|                                              |_______________A_M_____________| |
|                      |__________________M__A_____________________|             |
+--------------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       2160111     2281531.5     2234460.5     2228836.6     48249.299
+  10       2041120       2256035       2165759     2176119.5     67337.827
No difference proven at 95.0% confidence

```

On pf impact of forwarding:

```
x 295150.pf-statefull
+ 295150mbuf.pf-statefull
+--------------------------------------------------------------------------------+
|                                      +                                        x|
|+     +  *        +             ++ *  *   x   *       x      x     x           x|
|                             |____________________MA____________________|       |
|         |_______________A______M________|                                      |
+--------------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1410213       1465887     1442680.2     1443536.9     17152.332
+  10       1402970       1439733       1428782     1423177.4     12699.466
Difference at 95.0% confidence
        -20359.5 +/- 14179.5
        -1.41039% +/- 0.982273%
        (Student's t, pooled s = 15091)
```

On ipfw impact of forwarding:
```
x 295150.ipfw-statefull
+ 295150mbuf.ipfw-statefull
+--------------------------------------------------------------------------------+
|              +                                                                 |
|+   +  +     ++     *++                    +    x  x  x x       x x        xx  x|
|                                         |_________________AM_______________|   |
|    |_________M_A___________|                                                   |
+--------------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1539343       1608400     1586266.8     1584773.7     20518.892
+  10       1515709       1565736     1531985.5     1534220.4     13967.175
Difference at 95.0% confidence
        -50553.3 +/- 16491.3
        -3.18994% +/- 1.04061%
        (Student's t, pooled s = 17551.5)
```
