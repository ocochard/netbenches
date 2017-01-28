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
x r311848.pps
+ r311849.pps
* r312904.pps
% r312905.pps
+--------------------------------------------------------------------------+
|                                                        %                 |
|+                                                **     %%             xx |
|++ ++                                            ***    %%             xxx|
|                                                                       |A||
||MA|                                                                      |
|                                                 |A|                      |
|                                                        A|                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      617123.5      621593.5      618778.5      618825.3     1748.0416
+   5      461249.5        468798        462420      464462.7     3577.8329
Difference at 95.0% confidence
        -154363 +/- 4106.56
        -24.9445% +/- 0.635072%
        (Student's t, pooled s = 2815.72)
*   5        568013        573264        570714      570292.3      2111.109
Difference at 95.0% confidence
        -48533 +/- 2826.6
        -7.84276% +/- 0.442548%
        (Student's t, pooled s = 1938.1)
%   5        583070      586501.5        584191      584802.9     1586.9248
Difference at 95.0% confidence
        -34022.4 +/- 2434.76
        -5.4979% +/- 0.381743%
        (Student's t, pooled s = 1669.43)
```
