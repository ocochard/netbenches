Impact of adding VIMAGE support on forwarding/ipfw/pf performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 12-head 317849
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of adding VIMAGE support on forwarding/ipfw/pf performance](graph.png)


forwarding performance is improved (+1.45%):
```
x r317849 forwarding (packets-per-seconds)
+ r317849 with VIMAGE forwarding (packets-per-seconds)
+--------------------------------------------------------------------------+
|x            x            xx      x                +    +           + +  +|
|      |_____________A_____M_______|                                       |
|                                                      |_________A___M____||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        473689        479183        477790      476874.2     2162.0746
+   5        481840        485271        484511      483809.6     1505.1072
Difference at 95.0% confidence
        6935.4 +/- 2716.76
        1.45435% +/- 0.575296%
        (Student's t, pooled s = 1862.78)
```

ipfw performance is improved (+4%):

```
x r317849 ipfw-statefull (packets-per-seconds)
+ r317849 with VIMAGE ipfw-statefull (packets-per-seconds)
+--------------------------------------------------------------------------+
|x  x  x  x     x                                         +  +   +     +  +|
| |____MA_____|                                                            |
|                                                          |_____MA_____|  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        308361        312064        309761      309988.4      1420.591
+   5        322090        325998        323783      323971.2     1626.7144
Difference at 95.0% confidence
        13982.8 +/- 2227.24
        4.51075% +/- 0.732689%
        (Student's t, pooled s = 1527.13)
```

But pf performance is decreased:

```
x r317849 pf-statefull (packets-per-seconds)
+ r317849 with VIMAGE.pf-statefull (packets-per-seconds)
+--------------------------------------------------------------------------+
|+   +     +    +  +                                 x             xx  x x |
|                                                          |______A_M_____||
|  |______AM______|                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        274227        276536      275980.5      275767.3     903.42235
+   5        268022        270152        269161      269141.2     889.44123
Difference at 95.0% confidence
        -6626.1 +/- 1307.43
        -2.40279% +/- 0.468358%
        (Student's t, pooled s = 896.459)
```

flame graph:
   - [r317849 and forwarding](bench.317849.forwarding.svg)
   - [r317849 and ipfw-statefull](bench.317849.ipfw-statefull.svg)
   - [r317849 and pf-statefull](bench.317849.pf-statefull.svg)
   - [r317849 with VIMAGE and forwarding](bench.317849VIMAGE.forwarding.svg)
   - [r317849 with VIMAGE and ipfw-statefull](bench.317849VIMAGE.ipfw-statefull.svg)
   - [r317849 with VIMAGE and pf-statefull](bench.317849VIMAGE.pf-statefull.svg)

They were generated with this command (sched_idletd filtered):
```
stackcollapse-pmc.pl bench.312905.1.pmc.graph | grep -v sched_idletd | flamegraph.pl > bench.312905.svg

```
