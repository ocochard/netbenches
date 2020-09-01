Comparing wireguard userland vs kernel module
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 13-head r365033
  - Wireguard kernel: D26137
  - Wireguard userland: 1.0.20200827
  - 2000 flows of UDP packets
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
x   5           116           117           117         116.6    0.54772256
+   5           482           484           483         482.8    0.83666003
Difference at 95.0% confidence
	366.2 +/- 1.03127
	314.065% +/- 2.13802%
	(Student's t, pooled s = 0.707107)
```
