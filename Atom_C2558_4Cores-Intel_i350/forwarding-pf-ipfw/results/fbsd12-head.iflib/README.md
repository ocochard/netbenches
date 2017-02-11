Impact of IFLIB on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 12-head
  - Default igb drivers tuning
  - harvest.mask=351
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of IFLIB on forwarding performance](graph.png)

```
x 311848.pps
+ 311849.pps
* 312904.pps
% 312905.pps
# 313448.pps
@ 313448 with perf_netmap patch.pps
O 313448 with perf_netmap patch and a prefetch no-op.pps
+--------------------------------------------------------------------------+
|**   ** *  @@     #@   ## O% O O    O@ O  @O                  x  x   xx  x|
|                                                                |___AM__| |
|     |__MA__|                                                             |
||___AM_|                                                                  |
|           |_______A_______|                                              |
|                    |___A___|                                             |
|                        |________A__M_____|                               |
|                            |______AM_____|                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        931775        950261        942791      941183.3     7231.9269
+   5        832792        845024      836779.5      838433.1     5277.4615
Difference at 95.0% confidence
        -102750 +/- 9232.78
        -10.9171% +/- 0.912521%
        (Student's t, pooled s = 6330.58)
*   5        823657        838168        832143      830399.4     6109.7337
Difference at 95.0% confidence
        -110784 +/- 9763.38
        -11.7707% +/- 0.967975%
        (Student's t, pooled s = 6694.39)
%   5        842126      871285.5      856763.5      856599.8     13171.566
Difference at 95.0% confidence
        -84583.5 +/- 15496.3
        -8.98693% +/- 1.6134%
        (Student's t, pooled s = 10625.2)
#   5        855033        873337        865898      865020.9     6749.2584
Difference at 95.0% confidence
        -76162.4 +/- 10201.5
        -8.0922% +/- 1.03794%
        (Student's t, pooled s = 6994.76)
@   5        855791      895797.5      886086.5      880122.8     15567.531
Difference at 95.0% confidence
        -61060.5 +/- 17702.2
        -6.48763% +/- 1.85977%
        (Student's t, pooled s = 12137.7)
O   5      868384.5        897930        886929      884165.5     11717.577
Difference at 95.0% confidence
        -57017.8 +/- 14200.3
        -6.0581% +/- 1.48412%
        (Student's t, pooled s = 9736.59)
```

flame graph:
   - [r311848](311848.svg)
   - [r311849](311849.svg)
   - [r312904](312904.svg)
   - [r312905](312905.svg)
   - [r313448](313448.svg)
