Impact of glebius'mbuf not inlined" patch and ipfw/pf on forwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD projects/routing r287531
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - Traffic load at 14.48Mpps (10Gigabit line-rate)
  - harvest.mask=351

On forwarding:

```
x 295150.forwarding
+ 295150mbuf.forwarding
+--------------------------------------------------------------------------+
|                                                       +  +           x   |
|+                                                      + ++x*x+xxx++xxx   |
|                                                             |__MA___|    |
|                                  |___________________A___M______________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10     2152794.5       2296394     2218540.5     2228064.1     53129.482
+  10       1398873       2256546     2135847.5     2084121.2     246773.04
No difference proven at 95.0% confidence
```

On pf impact of forwarding:
```
x 295150.pf-statefull
+ 295150mbuf.pf-statefull
+--------------------------------------------------------------------------+
|+      x  +         ++ +x+  ++      +  +    xxx     x         x       x  x|
|                           |__________________MA___________________|      |
|           |___________AM__________|                                      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1411658       1473992     1448080.8     1449161.6     19005.696
+  10       1404914       1442182     1427449.2     1426807.7     11131.308
Difference at 95.0% confidence
        -22353.9 +/- 14633.6
        -1.54254% +/- 1.0098%
        (Student's t, pooled s = 15574.4)
```

On ipfw impact of forwarding:
```
x 295150.ipfw-statefull
+ 295150mbuf.ipfw-statefull
+--------------------------------------------------------------------------+
|         +         x  x                                                   |
|++ +     +  +  ++*+xx x     x                                            x|
|          |___________M___A________________|                              |
|   |______A______|                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10       1568092       1745910       1583280     1597500.4      52933.64
+  10       1513160       1569667     1546545.2     1544745.3     21251.565
Difference at 95.0% confidence
        -52755.1 +/- 37897.3
        -3.30235% +/- 2.37229%
        (Student's t, pooled s = 40333.6)

```
