WireGuard kernel vs userland
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - FreeBSD 13-head r365415
  - Wireguard kernel: D26137
  - Wireguard userland: 1.0.20200827
  - 5000 flows of clear UDP packets
  - 500Bytes UDP load => packet size: 528B => Ethernet frame size:542B

```
x Wireguard userland: Equilibrium Ethernet throughput in Mb/s
+ Wireguard kernel: Equilibrium Ethernet throughput in Mb/s
+--------------------------------------------------------------------------+
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|A                                                                         |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5          1640          1656          1655        1650.6     7.2663608
+   5          7661          7661          7661          7661             0
Difference at 95.0% confidence
	6010.4 +/- 7.49361
	364.134% +/- 2.10714%
	(Student's t, pooled s = 5.13809)
```

![WireGuard kernel vs userland on SuperServer 5018A-FTN4](graph.png)
