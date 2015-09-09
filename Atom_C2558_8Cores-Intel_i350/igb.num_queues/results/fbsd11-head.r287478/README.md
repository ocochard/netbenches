Impact of Intel i350 queue number on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-head.r287478
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of Intel i350 queue number on forwarding performance on FreeBSD 11-head.r287478](graph.svg)


```
x pps.1
+ pps.2
* pps.3
% pps.4
+------------------------------------------------------------------------+
|x                      +              *                               % |
|x                      +              *                               %%|
|x                      ++            **                               %%|
|A                                                                       |
|                       A|                                               |
|                                     |A                                 |
|                                                                      MA|
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        171648        172780        172061        172175     439.21521
+   5        270620        273089        271194      271487.8     1000.2328
Difference at 95.0% confidence
	99312.8 +/- 1126.58
	57.6813% +/- 0.654324%
	(Student's t, pooled s = 772.456)
*   5        331056        334399        332711      332740.6     1184.9917
Difference at 95.0% confidence
	160566 +/- 1303.29
	93.2572% +/- 0.756959%
	(Student's t, pooled s = 893.621)
%   5        471012        475120        472380      473061.4     1687.1514
Difference at 95.0% confidence
	300886 +/- 1797.91
	174.756% +/- 1.04423%
	(Student's t, pooled s = 1232.76)
```
