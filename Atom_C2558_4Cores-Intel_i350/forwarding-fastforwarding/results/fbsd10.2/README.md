Comparing impact of patch [D5330] (https://reviews.freebsd.org/D5330) on 10.2 forwarding/fastforwarding
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 10.2 and 10-stable
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

This patch, on this setup, reduce forwarding performance by -9% (+/- 1%):

Comparing 10.2 forwarding/fastforwarding and 10-stable tryforward with [D5330] (https://reviews.freebsd.org/D5330) impact
```
x 10.2 forwarding (pps)
+ 10.2 fastforwarding (pps)
* 10-stable r295802 with D5330
+--------------------------------------------------------------------------+
|                                                  *                       |
|                                                  *                       |
|                                                * *                       |
|xx   x                                         ** *               +++ +   |
|xx   x                                         ** *               +++ ++ +|
||MA_|                                                                     |
|                                                                  |_MA_|  |
|                                               |_A|                       |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        381295      405347.5      384301.5     389779.85     10183.979
+  10        701671        736395      713076.5      714775.6     11127.311
Difference at 95.0% confidence
        324996 +/- 10021.8
        83.3793% +/- 2.57114%
        (Student's t, pooled s = 10666.1)
*  10        608019        624612        617817     617255.35     6681.9961
Difference at 95.0% confidence
        227476 +/- 8092.6
        58.36% +/- 2.0762%
        (Student's t, pooled s = 8612.85)
```
