Impact of fast-io feature on OpenVPN performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 13-head r365328
  - AESNI module loaded
  - OpenVPN 2.4.9
  - 5000 flows of UDP packets
  - 500Bytes UDP load => packet size: 528B => Ethernet frame size:542B

```
x aes-gcm-256: Equilibrium Ethernet throughput in Mb/s
+ aes-gcm-256 with fastio: Equilibrium Ethernet throughput in Mb/s
+--------------------------------------------------------------------------+
|          x                                                    +          |
|          x                                                    +          |
|x         x                                         +          +         +|
|    |___A_M__|                                                            |
|                                                       |_______A______|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5            56            57            57          56.8     0.4472136
+   5            61            63            62            62    0.70710678
Difference at 95.0% confidence
	5.2 +/- 0.862826
	9.15493% +/- 1.56006%
	(Student's t, pooled s = 0.591608)
```

Null crypto:

```
x null: Equilibrium Ethernet throughput in Mb/s
+ null with fastio: Equilibrium Ethernet throughput in Mb/s
+--------------------------------------------------------------------------+
|                                    x                  +                  |
|+                 *                 x                  *                 +|
|                        |___________A____________|                        |
|          |_____________________________A______________M______________|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5            80            82            81            81    0.70710678
+   5            79            83            82          81.2     1.6431677
No difference proven at 95.0% confidence
```
