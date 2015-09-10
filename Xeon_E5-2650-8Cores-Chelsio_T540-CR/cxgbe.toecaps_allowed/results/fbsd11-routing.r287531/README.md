Impact of disabling cxgbe.toecaps_allowed on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 10.2
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - ntxq10g and nrxq10g = 4 (and not the default value of ncpu=8)
  - Traffic load at 10Mpps


```
x pps.default_allowed
+ pps.disallowed
+--------------------------------------------------------------------------+
|    xx   ++  + xx      x        +                                        +|
|     |_______A_M_____|                                                    |
||____________M_____________A__________________________|                   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       5073726       5114769       5097956     5092452.8     17184.514
+   5       5083797       5223018       5092212     5123924.8     58866.836
No difference proven at 95.0% confidence
```
