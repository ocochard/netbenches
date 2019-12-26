IPSec performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11.0
  - Encryption algorithms: aes-cbc-128 (rijndael-cbc), no authentication algorithm
  - 2000 flows of UDP packets
  - 500B UDP load => packet size: 528B => Ethernet frame size:542B

![IPSec performance with FreeBSD 11.0 on PC Engines APU2C4](graph.png)


```
x aes-cbc-128-NOaesni.data
+ aes-cbc-128-aesni.data
+--------------------------------------------------------------------------+
|xx                                                                    + + |
|xxx                                                                   + ++|
||A|                                                                       |
|                                                                      |_A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5           301           303           302         301.8    0.83666003
+   5           376           379           378         377.4     1.3416408
Difference at 95.0% confidence
        75.6 +/- 1.63059
        25.0497% +/- 0.540288%
        (Student's t, pooled s = 1.11803)
```
