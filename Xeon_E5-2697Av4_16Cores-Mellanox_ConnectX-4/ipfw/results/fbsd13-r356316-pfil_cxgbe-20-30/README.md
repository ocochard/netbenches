Receiving legitimate traffic at 20Mpps, DDoS at 30Mpps
```
x ipfw-standard.pps
+ ipfw-at-nic-level.pps
+--------------------------------------------------------------------------+
| xx                                                                      +|
|xxx                                                               +  ++  +|
||A|                                                                       |
|                                                                   |__A__||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11826631      11981330      11907152      11916602      64591.84
+   5      16596365      17112466      16898094      16917305     212549.52
Difference at 95.0% confidence
	5.0007e+06 +/- 229095
	41.9642% +/- 2.0033%
	(Student's t, pooled s = 157082)
```
