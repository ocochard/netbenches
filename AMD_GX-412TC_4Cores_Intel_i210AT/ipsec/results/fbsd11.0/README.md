IPSec performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11.0
  - Encryption algorithms: aes-cbc-128 (rijndael-cbc), no authentication algorithm
  - 2000 flows of UDP packets
  - 500B UDP load => packet size: 528B => Ethernet frame size:542B

![IPSec performance with FreeBSD 11.0 on PC Engines APU2C4](graph.png)


```
x fastforwarding.pps
+ ipfw-statefull.pps
* pf-statefull.pps
+--------------------------------------------------------------------------+
|*          +                                                              |
|*          +                                                              |
|*          +                                                              |
|*          +                                                        x     |
|**         +                                                        x     |
|**         +                                                        x  x x|
|**       ++++                                                       x xxxx|
|                                                                    |_AM| |
|          |A|                                                             |
|A|                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        361105        373126        367820     366641.75     4723.0113
+  10        229056        234122     232831.75     232400.35     1501.7561
Difference at 95.0% confidence
        -134241 +/- 3292.75
        -36.6138% +/- 0.898084%
        (Student's t, pooled s = 3504.43)
*  10        207740        210328        208701      208738.7      686.9941
Difference at 95.0% confidence
        -157903 +/- 3170.96
        -43.0674% +/- 0.864867%
        (Student's t, pooled s = 3374.82)
```
