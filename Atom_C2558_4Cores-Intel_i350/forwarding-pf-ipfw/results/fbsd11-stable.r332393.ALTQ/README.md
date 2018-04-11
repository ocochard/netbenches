Impact of enabling ALTQ on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-stable r332393
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

```
x 11-stable r332393: inet4 packets-per-second forwarded
+ 11-stable r332393 with ALTQ: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+                                                                         |
|+                                                                         |
|+                                                                      x  |
|++                                                                   xxx x|
|                                                                     |_A| |
|A                                                                         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        998423       1032129     1015863.5     1014039.8     12644.734
+   5        482027        486156        483680      483708.1       1610.71
Difference at 95.0% confidence
	-530332 +/- 13145.6
	-52.2989% +/- 0.634914%
	(Student's t, pooled s = 9013.43)
```

Flamegraph:
   - [Generic No-debug](bench.r332393.1.pmc.svg)
   - [Generic No-debug with ALTQ](bench.r332393ALTQ.1.pmc.svg)
