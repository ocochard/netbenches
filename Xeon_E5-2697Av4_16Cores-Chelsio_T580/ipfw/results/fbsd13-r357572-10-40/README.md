Forwarding rate of 10Mpps legitimate traffic while filtering the 40Mpps of DDoS using the different configuration sets:
```
x ipfw-standard
+ ipfw-at-nic-level
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|  x                                                                      +|
|  x                                                                      +|
|x xx                                                                     +|
| |A|                                                                      |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       8914640       8952274       8937470     8936274.4     13641.297
+   5       9700393       9702721       9701538     9701557.1     1097.1177
Difference at 95.0% confidence
	765283 +/- 14113.3
	8.56378% +/- 0.171375%
	(Student's t, pooled s = 9677)
```

Flamegraphs:
  - [ipfw-standard](bench.ipfw-standard.1.pmc.svg)
  - [ipfw-at-nic-level](bench.ipfw-at-nic-level.1.pmc.svg)
