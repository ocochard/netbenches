Impact of an if_bridge on forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX lock) patches
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps
  - harvest.mask=351

no bridge setup:
cxl0 (input) -> cxl1 (output)

bridge setup:
cxl0 (added to bridge0, IP address on bridge0) -> cxl1 (output)


```
x no bridge: inet4 packets-per-second
+ with a bridge: inet4 packets-per-second
+--------------------------------------------------------------------------+
|+ +                                                                     x |
|+++                                                              x    xxx |
|                                                                   |__AM_||
||A|                                                                       |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4158237       4398713       4353693     4325312.2      97094.05
+   5       1902568       1972191       1949794     1939253.2     34507.953
Difference at 95.0% confidence
	-2.38606e+06 +/- 106267
	-55.165% +/- 1.32447%
	(Student's t, pooled s = 72863.1)
```

Flamegraph:
   - [without if_bridge](bench.bridge.svg)
   - [with if_bridge](bench.no-bridge.svg)
