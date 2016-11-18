Impact of mjg@'s commit r303643 "Implement trivial backoff for locking primitives" on forwarding/ipfw/pf performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 12-head
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps
  - ntxq10g and nrxq10g = number of core (default) = 8
  - harvest.mask=351

![Impact of mjg@'s commit r303643 "Implement trivial backoff for locking primitives" on forwarding/ipfw/pf performance](graph.png)

ministat status with forwarding improvement:

```
x 303642.forwarding.pps
+ 303643.forwarding.pps
+--------------------------------------------------------------------------+
|xx                                                               +        |
|xxx                                                             +++      +|
||A|                                                                       |
|                                                               |_M_A__|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        625167        641688        635734      633707.9     6580.0951
+   5       1138692       1207046       1146448     1156573.7     28649.353
Difference at 95.0% confidence
        522866 +/- 30314.6
        82.509% +/- 5.05534%
        (Student's t, pooled s = 20785.6)
```

ministat status with ipfw improvement:

```
x 303642.ipfw-statefull.pps
+ 303643.ipfw-statefull.pps
+--------------------------------------------------------------------------+
|x           x x   x                  +               +       +        + + |
|     |______A_M___|                                                       |
|                                            |______________A_M___________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      800478.5      863624.5      848446.5      841101.7     23876.499
+   5        930427       1055229       1014607     1006693.4     50505.652
Difference at 95.0% confidence
        165592 +/- 57612.2
        19.6875% +/- 7.11505%
        (Student's t, pooled s = 39502.6)
```

ministat status with pf improvement:

```
x 303642.pf-statefull.pps
+ 303643.pf-statefull.pps
+--------------------------------------------------------------------------+
|       +                                                                  |
|+   +  + +                                                     x xx x    x|
|                                                               |__MA___|  |
|  |__A_M_|                                                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1091242     1111744.5       1097719     1099597.7     7613.8706
+   5        963866        981614        977080      974662.7     6874.2091
Difference at 95.0% confidence
        -124935 +/- 10578.8
        -11.3619% +/- 0.903476%
        (Student's t, pooled s = 7253.47)
```
