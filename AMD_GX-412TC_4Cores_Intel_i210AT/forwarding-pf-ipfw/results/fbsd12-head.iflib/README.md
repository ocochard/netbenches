Impact of IFLIB on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 12-head
  - 2000 flows of smallest UDP packets
  - No drivers tunning (default value)
  - harvest.mask=351
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of IFLIB on forwarding performance on FreeBSD 12-head](graph.png)


```
x 311848.pps
+ 311849.pps
* 312904.pps
% 312905.pps
# 313448.pps
@ 313448perf_netmap.pps
O 313448perf_netmapnoprefetch.pps
+--------------------------------------------------------------------------+
|                                                          O               |
|                                                          O               |
|+++              # ##                       @@@ OO  % %%%OOO          xxxx|
|                                                                      |A| |
||A|                                                                       |
|                                                |A                        |
|                                                     |A_|                 |
|                  |A|                                                     |
|                                            |_A_|                         |
|                                                         |A|              |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        621955      628503.5      624595.5      624614.7     2660.6611
+   5      462666.5        466679        465402      464775.7     1687.0162
Difference at 95.0% confidence
        -159839 +/- 3248.95
        -25.59% +/- 0.429453%
        (Student's t, pooled s = 2227.68)
*   5      570701.5      575035.5        572907      573139.4     1791.9755
Difference at 95.0% confidence
        -51475.3 +/- 3308.17
        -8.24113% +/- 0.500016%
        (Student's t, pooled s = 2268.29)
%   5        581032        588829        586193      585794.4     3061.5241
Difference at 95.0% confidence
        -38820.3 +/- 4182.97
        -6.21508% +/- 0.652104%
        (Student's t, pooled s = 2868.1)
#   5        502255      508858.5        506829      506370.7     2636.5772
Difference at 95.0% confidence
        -118244 +/- 3862.9
        -18.9307% +/- 0.562429%
        (Student's t, pooled s = 2648.65)
@   5        562036      572904.5        567603      567593.1     4413.2947
Difference at 95.0% confidence
        -57021.6 +/- 5314.45
        -9.12908% +/- 0.830841%
        (Student's t, pooled s = 3643.92)
O   5        591294        595708        594615      594325.9     1772.5997
Difference at 95.0% confidence
        -30288.8 +/- 3297.05
        -4.8492% +/- 0.510262%
        (Student's t, pooled s = 2260.67)
```

flame graph:
   - [r311848](bench.311848.svg)
   - [r311849](bench.311849.svg)
   - [r312904](bench.312904.svg)
   - [r312905](bench.312905.svg)
   - [r313448](bench.313448.svg)

