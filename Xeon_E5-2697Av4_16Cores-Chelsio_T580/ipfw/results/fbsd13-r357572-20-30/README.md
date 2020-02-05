Forwarding rate of 20Mpps legitimate traffic while filtering 30Mpps of DDoS using different configuration sets:
```
x ipfw-standard
+ ipfw-at-nic-level
+--------------------------------------------------------------------------+
|                                                                        + |
|      x                                                                 ++|
|x  x  xx                                                                ++|
|  |_A_M|                                                                  |
|                                                                        A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      12647080      12914498      12880632      12825694     112196.81
+   5      15586889      15633830      15600631      15607284     19418.127
Difference at 95.0% confidence
	2.78159e+06 +/- 117426
	21.6876% +/- 1.10884%
	(Student's t, pooled s = 80514.6)
```
Flamegraphs:
  - [ipfw-standard](bench.ipfw-standard.1.pmc.svg)
  - [ipfw-at-nic-level](bench.ipfw-at-nic-level.1.pmc.svg)
