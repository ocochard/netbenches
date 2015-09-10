Impact of Intel i350 queue number on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-routing.r287531
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of Intel i350 queue number on forwarding performance on FreeBSD 11-routing.r287531](graph.png)


```
x pps.1
+ pps.2
* pps.3
% pps.4
+------------------------------------------------------------------------+
|                                                                      % |
| +                    *                                               % |
|++                    *                                              x% |
|++                    ***                                          x x##|
|                                                                    |A| |
|AM                                                                      |
|                      MA|                                               |
|                                                                      A||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        586080        598986        594534      593430.8     4698.4986
+   5        308706        312296        310967        310550      1702.038
Difference at 95.0% confidence
	-282881 +/- 5153.57
	-47.6687% +/- 0.868436%
	(Student's t, pooled s = 3533.61)
*   5        397282        409355        401109        402068      4516.769
Difference at 95.0% confidence
	-191363 +/- 6721.28
	-32.2469% +/- 1.13261%
	(Student's t, pooled s = 4608.53)
%   5        595180        600829        596977      597321.2     2134.6383
No difference proven at 95.0% confidence
```
