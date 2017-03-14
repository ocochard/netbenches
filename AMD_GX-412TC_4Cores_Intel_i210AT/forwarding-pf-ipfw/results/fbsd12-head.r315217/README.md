Impact of r315217 on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 12-head
  - 2000 flows of smallest UDP packets
  - No drivers tunning (default value)
  - harvest.mask=351
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of r315217 on forwarding performance on FreeBSD 12-head](graph.png)


```
x r315216.forwarding.paquets-per-second
+ r315217.forwarding.paquets-per-second
+--------------------------------------------------------------------------+
|+                                                                         |
|+                                                                         |
|+                                                                        x|
|++                                                                    xxxx|
|                                                                       |A||
|A|                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        636852        642978        641441      640401.4     2735.4083
+   5      468435.5        470044        468549      468969.3     686.91062
Difference at 95.0% confidence
        -171432 +/- 2908.54
        -26.7695% +/- 0.341018%
        (Student's t, pooled s = 1994.28)

```

flame graph:
   - [r315216](bench.315216.svg)
   - [r315217](bench.315217.svg)

They were generated with this command (sched_idletd filtered):
```
stackcollapse-pmc.pl bench.312905.1.pmc.graph | grep -v sched_idletd | flamegraph.pl > bench.312905.svg

```
