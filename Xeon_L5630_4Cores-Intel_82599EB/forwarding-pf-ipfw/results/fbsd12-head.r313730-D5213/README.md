Impact of D5213 (convert ixgbe to iflib) on forwarding performance:
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 12-head r313730 
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - harvest.mask=351
  - Traffic load at 14.48Mpps (10Gigabit line-rate)

![ipfw/pf impact on forwarding performance on FreeBSD 11-stable](graph.png)

```
x r313730, paquets-per-second
+ r313730-D5213, paquets-per-second
+--------------------------------------------------------------------------+
|      +                                                        x          |
|     ++               x                   ++                 x xx         |
|                                    |__________________A_______M_________||
||_____M_____________A___________________|                                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2439877     2923715.5     2907858.5     2816269.4     210659.57
+   5     2251528.5       2679501       2259267     2424025.7     229988.26
Difference at 95.0% confidence
        -392244 +/- 321639
        -13.9278% +/- 10.7244%
        (Student's t, pooled s = 220536)

```

flame graphs:
   - [r313730](bench.313730.svg)
   - [r313730-D5213](bench.313730-D5213.svg)
