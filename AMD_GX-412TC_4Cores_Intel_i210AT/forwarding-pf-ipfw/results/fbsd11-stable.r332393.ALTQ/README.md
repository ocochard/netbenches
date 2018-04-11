Impact of enabling ALTQ on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11-stable (r332393)
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

```
x 11-stable r332393: inet4 packets-per-second forwarded
+ 11-stable r332393 with ALTQ: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|  +                                                                   x  x|
|+++ +                                                                 x xx|
|                                                                      |_A||
||_A|                                                                      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        678388        687129        684108        683035     4180.9609
+   5        474207        484429        478652      478832.6     3767.0484
Difference at 95.0% confidence
	-204202 +/- 5803.71
	-29.8963% +/- 0.720646%
	(Student's t, pooled s = 3979.39)
```

Flamegraph:
   - [Generic No-debug](bench.r332393.1.pmc.svg)
   - [Generic No-debug with ALTQ](bench.r332393ALTQ.1.pmc.svg)
