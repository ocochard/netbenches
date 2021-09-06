Comparing MAIN vs STABLE-13 on firewalling performance:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - RX NIC (heavy work): Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - TX NIC: Mellanox_ConnectX-4
  - Increase number of Chelsio RX & TX queues to 32
  - FreeBSD STABLE n265892 and MAIN n268154
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - ICMP redirect disabled

![Impact of IPv4 firewalling: MAIN vs STABLE-12 vs STABLE-13](graph.IPv4.png)
![Impact of IPv6 firewalling: MAIN vs STABLE-12 vs STABLE-13](graph.IPv6.png)

Forwarding diff:

```
x STABLE-12: forwarded inet packets-per-second
+ STABLE-13: forwarded inet packets-per-second
* MAIN: forwarded inet packets-per-second
+--------------------------------------------------------------------------+
|                                                                        * |
|                                         +                              **|
|xxxxx                     +          +  ++                              **|
||_A|                                                                      |
|                               |_____A__M___|                             |
|                                                                        A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      24750217      24987843      24854170      24865274      90442.04
+   5      26317649      27219814      27145666      26975666     380723.47
Difference at 95.0% confidence
        2.11039e+06 +/- 403557
        8.48731% +/- 1.63063%
        (Student's t, pooled s = 276704)
*   5      29048619      29120288      29090342      29084260     29663.541
Difference at 95.0% confidence
        4.21899e+06 +/- 98159.2
        16.9674% +/- 0.455672%
        (Student's t, pooled s = 67304.1)
```

```
x STABLE12.forwarding.inet6.pps
+ STABLE13.forwarding.inet6.pps
* MAIN.forwarding.inet6.pps
+--------------------------------------------------------------------------+
|                                                                      *   |
|x  xx   x  x                                    ++    +   ++          ****|
| |__MA___|                                                                |
|                                                 |____A____|              |
|                                                                      |A| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      24278724      24796012      24466188      24519836      205300.6
+   5      26569904      27063426      26824165      26821570     228087.35
Difference at 95.0% confidence
        2.30173e+06 +/- 316472
        9.38723% +/- 1.34625%
        (Student's t, pooled s = 216993)
*   5      27578369      27732120      27643505      27646290     58914.394
Difference at 95.0% confidence
        3.12645e+06 +/- 220266
        12.7507% +/- 1.00461%
        (Student's t, pooled s = 151029)
```

IPFW diff:

```
x STABLE12.ipfw-stateless.inet4.pps
+ STABLE13.ipfw-stateless.inet4.pps
* MAIN.ipfw-stateless.inet4.pps
+--------------------------------------------------------------------------+
|+      +++         xxx                                   *   ** *        *|
|                   |A|                                                    |
|   |__A_M_|                                                               |
|                                                          |___MA_____|    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      17001876      17080068      17047150      17044738     31593.977
+   5      16489275      16739783      16706170      16666688     100990.05
Difference at 95.0% confidence
        -378050 +/- 109126
        -2.21799% +/- 0.63898%
        (Student's t, pooled s = 74823.7)
*   5      18070269      18502947      18193256      18238849     161506.63
Difference at 95.0% confidence
        1.19411e+06 +/- 169715
        7.00574% +/- 0.998358%
        (Student's t, pooled s = 116367)
```

```
x STABLE12.ipfw-stateful.inet4.pps
+ STABLE13.ipfw-stateful.inet4.pps
* MAIN.ipfw-stateful.inet4.pps
+--------------------------------------------------------------------------+
|+   *+    *   ++   * +  *                              *  x     x   x   xx|
|                                                             |_____AM____||
|  |________A__M____|                                                      |
|   |_______________M___A__________________|                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14713248      15024747      14927820      14900325     126519.36
+   5      13498056      13937430      13787662      13723512     176036.66
Difference at 95.0% confidence
        -1.17681e+06 +/- 223566
        -7.8979% +/- 1.46113%
        (Student's t, pooled s = 153291)
*   5      13587740      14660266      13893680      13970300     417375.14
Difference at 95.0% confidence
        -930025 +/- 449770
        -6.24164% +/- 3.00312%
        (Student's t, pooled s = 308390)
```

PF diff:

```
x STABLE12.pf-stateful.inet4.pps
+ STABLE13.pf-stateful.inet4.pps
* MAIN.pf-stateful.inet4.pps
+--------------------------------------------------------------------------+
|+   +       ++      x xx   x      *** *                                  *|
|                   |__A___|                                               |
|  |_____A___M_|                                                           |
|                           |________M______A________________|             |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      13001601      13301532      13100052      13110131     120366.13
+   5      12223795      12723082      12677480      12541658     222761.13
Difference at 95.0% confidence
        -568473 +/- 261119
        -4.33613% +/- 1.97255%
        (Student's t, pooled s = 179040)
*   5      13561145      15102932      13648817      13928698     659228.09
Difference at 95.0% confidence
        818567 +/- 691085
        6.24377% +/- 5.28232%
        (Student's t, pooled s = 473851)
```

```
x STABLE12.pf-stateless.inet4.pps
+ STABLE13.pf-stateless.inet4.pps
* MAIN_n268154.pf-stateless.inet4.pps
+--------------------------------------------------------------------------+
|                                                    *                     |
|+  +        +       +    +                          *  **      *  xxx    x|
|                                                           |______AM____| |
| |__________A__________|                                                  |
|                                                   |___MA___|             |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11379676      11733672      11612774      11589526     129565.71
+   5      10309062      10802570      10542491      10541138     210377.99
Difference at 95.0% confidence
        -1.04839e+06 +/- 254802
        -9.046% +/- 2.1457%
        (Student's t, pooled s = 174709)
*   5      11325704      11547108      11375250      11396719     89938.899
Difference at 95.0% confidence
        -192807 +/- 162655
        -1.66363% +/- 1.38775%
        (Student's t, pooled s = 111526)
```
