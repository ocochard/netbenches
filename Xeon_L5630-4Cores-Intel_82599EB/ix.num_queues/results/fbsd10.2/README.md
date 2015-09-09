Impact of Intel 82599EB queue number on forwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 10.2
  - 2000 flows of smallest UDP packets
  - Traffic load at 14.48Mpps (10Gigabit line-rate)

![Impact of Intel 82599EB queue number on forwarding performance on FreeBSD 10.2](graph.svg)


```
x pps.one
+ pps.two
* pps.four
+--------------------------------------------------------------------------+
|    x                          +                                      *   |
|    x               x        + +              +     *            *   **   |
||___M__A______|                                                           |
|                           |___M__A_____|                                 |
|                                                         |_______A___M___||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        735764       1046702        742025      801718.6     136977.36
+   5       1222021       1525798       1254384       1302816      125493.6
Difference at 95.0% confidence
	501097 +/- 191583
	62.5029% +/- 23.8965%
	(Student's t, pooled s = 131361)
*   5       1644108       1996257       1976415     1898188.4     147844.08
Difference at 95.0% confidence
	1.09647e+06 +/- 207849
	136.765% +/- 25.9254%
	(Student's t, pooled s = 142514)
```
