Comparing wireguard userland vs kernel module
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 13-head r365033
  - Wireguard kernel: D26137
  - Wireguard userland: 1.0.20200827
  - 2000 flows of UDP packets
  - 500Bytes UDP load => packet size: 528B => Ethernet frame size:542B

```
x Wireguard userland: Equilibrium Ethernet throughput in Mb/s
+ Wireguard kernel: Equilibrium Ethernet throughput in Mb/s
+--------------------------------------------------------------------------+
|x                                                                       ++|
|x                                                                      +++|
|A                                                                         |
|                                                                        A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5           149           149           149           149             0
+   5           600           611           608         607.4     4.5055521
Difference at 95.0% confidence
	458.4 +/- 4.64646
	307.651% +/- 3.11843%
	(Student's t, pooled s = 3.18591)
```
