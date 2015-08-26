Impact of number of static route on forwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 10.2
  - 2000 flows of smallest UDP packets
  - Traffic load at 14.48Mpps (10Gigabit line-rate)

![Number of static routes on forwarding performance](graph.png)

```
x pps.one-route
+ pps.four-routes
* pps.eight-routes
+--------------------------------------------------------------------------+
|                   *                                                      |
|                   *                                                      |
|   x      x   + +  *         x           x                   +  +       **|
||_________M______A________________|                                       |
|         |_________M_______________A________________________|             |
|           |_______M____________________A_____________________________|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1639912       1984116       1704942     1769454.2     154632.18
+   5       1737180       2194547       1785163     1927662.8     229585.57
No difference proven at 95.0% confidence
*   5       1782648       2273933       1785695     1978219.6     266278.12
No difference proven at 95.0% confidence
```
