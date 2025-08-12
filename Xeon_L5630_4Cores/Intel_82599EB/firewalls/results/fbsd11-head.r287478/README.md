Impact of enabling ipfw or pf on fastforwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 11 head r287478
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - Traffic load at 14.48Mpps (10Gigabit line-rate)
  - harvest.mask=351

![Impact of enabling ipfw or pf on forwarding performance on FreeBSD 11 head r287478](graph.png)


```
x pps.fastforwarding
+ pps.ipfw-statefull
* pps.pf-statefull
+--------------------------------------------------------------------------+
|*                   * ***     ++  + +         x  xxx                     x|
|                                           |______M___A__________|        |
|                             |_MA__|                                      |
|        |_________A___M_____|                                             |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1701503       2076405       1761899       1813196     149995.66
+   5       1482012       1575294       1498054     1517159.8     39279.013
Difference at 95.0% confidence
        -296036 +/- 159903
        -16.3268% +/- 8.81882%
        (Student's t, pooled s = 109639)
*   5       1077324       1411857       1380141     1323449.4     139228.53
Difference at 95.0% confidence
        -489747 +/- 211055
        -27.0101% +/- 11.6399%
        (Student's t, pooled s = 144712)
```
