Impact of adding D12685 on ipfw performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 12-head r325006
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps

inet4:

```
x r325006: inet4 packets-per-second
+ r325006 with D12685: inet4 packets-per-second
+--------------------------------------------------------------------------+
| x     x       x    x                                        +  +   + +  +|
||______M_A_______|                                                        |
|                                                              |____AM___| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4926226       5061461       4968007     4982323.8     61171.031
+   5     5354928.5       5439683       5400744     5397190.5     33366.021
Difference at 95.0% confidence
	414867 +/- 71858.4
	8.32677% +/- 1.53565%
	(Student's t, pooled s = 49270.6)
```

inet6:

```
x r325006: inet6 packets-per-second
+ r325006 with D12685: inet6 packets-per-second
+--------------------------------------------------------------------------+
|xxx                                                            +  ++ +   +|
||A|                                                                       |
|                                                                |__MA__|  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3495513       3522367       3504904     3508423.8     11667.122
+   5       4373025       4506515       4425156       4433615     50334.836
Difference at 95.0% confidence
	925191 +/- 53285.2
	26.3706% +/- 1.54172%
	(Student's t, pooled s = 36535.7)
```

flame graph:
   - [r325006: inet4](bench.325006.inet4.1.pmc.svg)
   - [r325006: inet6](bench.325006.inet6.1.pmc.svg)
   - [r325006 with D12685: inet4](bench.325006D12685.inet4.1.pmc.svg)
   - [r325006 with D12685: inet6](bench.325006D12685.inet6.1.pmc.svg)

