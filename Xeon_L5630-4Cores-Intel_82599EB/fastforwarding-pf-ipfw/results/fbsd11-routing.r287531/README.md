Impact of enabling ipfw or pf on fastforwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD projects/routing r287531
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - Traffic load at 14.48Mpps (10Gigabit line-rate)
  - harvest.mask=351

![Impact of enabling ipfw or pf on forwarding performance on FreeBSD projects/routing r287531](graph.png)


```
x pps.fastforwarding
+ pps.ipfw-statefull
* pps.pf-statefull
+--------------------------------------------------------------------------+
| *                                                                        |
| *            +                                                           |
| *            +                    x                                      |
|**          + +  +                 xx                                  x x|
|                              |_____M_____________A___________________|   |
|             |A_|                                                         |
||A                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2350475       3179081       2371321     2678834.4     433447.88
+   5       1866499       1967758       1906097     1908262.4     37169.083
Difference at 95.0% confidence
        -770572 +/- 448644
        -28.7652% +/- 16.7477%
        (Student's t, pooled s = 307619)
*   5       1598104       1623079       1620090       1614828     10626.267
Difference at 95.0% confidence
        -1.06401e+06 +/- 447138
        -39.719% +/- 16.6915%
        (Student's t, pooled s = 306586)
```
