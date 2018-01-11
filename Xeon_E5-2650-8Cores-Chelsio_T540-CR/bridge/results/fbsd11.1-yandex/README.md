Impact of adding an if_bridge on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX lock) patches
  - 2000 flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - harvest.mask=351

no bridge setup:
cxl0 (input) -> cxl1 (output)

bridge setup:
cxl0 (added to bridge0, IP address on bridge0) -> cxl1 (output)


```
x no if_bridge: inet4 packets-per-second
+ with if_bridge: inet4 packets-per-second
+--------------------------------------------------------------------------+
|  +                                                                      x|
|++++                                                                    xx|
|                                                                        |A|
||AM|                                                                      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11102006      11179490      11155098      11149783     28766.212
+   5       4040161       4322481     4201494.5     4178806.5     113801.03
Difference at 95.0% confidence
	-6.97098e+06 +/- 121051
	-62.5212% +/- 1.05729%
	(Student's t, pooled s = 83000.5)
```

Flamegraph:
   - [without if_bridge](bench.bridge.svg)
   - [with an if_bridge](bench.no-bridge.svg)

