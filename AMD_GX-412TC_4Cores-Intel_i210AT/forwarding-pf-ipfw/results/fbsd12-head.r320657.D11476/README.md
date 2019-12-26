Impact of D11476 on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 12-head 317849
  - LRO/TSO disabled
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of D11476 on forwarding performance](graph.png)

inet 4 forwarding performance is improved (+2.9%):
```
x r320657, inet4 packets-per-second
+ r320657 with D11476, inet4 packets-per-second
+--------------------------------------------------------------------------+
|        x                                                          +      |
|xx      x x                                                       ++   + +|
| |___A__M_|                                                               |
|                                                                  |M_A__| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        462894        465011        464490        464002      951.0602
+   5        476909        478369        477130      477482.2     648.55663
Difference at 95.0% confidence
        13480.2 +/- 1187.15
        2.9052% +/- 0.260947%
        (Student's t, pooled s = 813.984)
```

inet6 forwarding performance not impacted:
```
x r320657, inet6 packets-per-second
+ r320657 with D11476, inet6 packets-per-second
+--------------------------------------------------------------------------+
|+       +      +       x   x           +   x   +                         x|
|                        |__________________M____A_______________________| |
| |_____________M______A___________________|                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        433045      438900.5      435451.5        435969     2818.8255
+   5      430381.5        435821        432123      432897.2     2349.4506
No difference proven at 95.0% confidence
```

flame graph:
   - [inet4 forwarding on r320657](bench.320657.inet4.1.pmc.svg)
   - [inet6 forwarding on r320657](bench.320657.inet6.1.pmc.svg)
   - [inet4 forwarding on r320657 with D11476](bench.320657D11476.inet4.1.pmc.svg)
   - [inet6 forwarding on r320657 with D11476](bench.320657D11476.inet6.1.pmc.svg)

They were generated with this command (sched_idletd filtered):
```
stackcollapse-pmc.pl bench.312905.1.pmc.graph | grep -v sched_idletd | flamegraph.pl > bench.312905.svg

```
