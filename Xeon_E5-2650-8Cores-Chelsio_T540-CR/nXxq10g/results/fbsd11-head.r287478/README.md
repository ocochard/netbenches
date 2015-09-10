Impact of Chelsio rx/tx queue number on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11-head.r287478
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - ntxq10g and nrxq10g = 1, 2, 4 and 8 (=number of core=default on this setup)
  - Traffic load at 10 Mpps

![Impact of Chelsio rx/tx queue number on forwarding performance on FreeBSD 11-head.r287478](graph.png)


```
x pps.1
+ pps.2
* pps.3
% pps.4
# pps.5
@ pps.6
O pps.8
+--------------------------------------------------------------------------+
|x           OO    OO     ++ + O  *O*@*@   @ @      ##   #    % %#      % %|
|A                                                                         |
|                          |AM|                                            |
|                                  |A_|                                    |
|                                                              |_____A__M_||
|                                                  |_____A____|            |
|                                   |__MA___|                              |
|           |______A_______|                                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1199575       1201642       1201118     1200774.4     891.16009
+   5       1733571       1805593       1795651     1779805.2     32164.474
Difference at 95.0% confidence
	579031 +/- 33183.1
	48.2214% +/- 2.76348%
	(Student's t, pooled s = 22752.4)
*   5       1913588       1995633       1944448     1953592.4     34176.044
Difference at 95.0% confidence
	752818 +/- 35256.9
	62.6944% +/- 2.93618%
	(Student's t, pooled s = 24174.3)
%   5       2494966       2749126       2707433     2642876.2     112702.85
Difference at 95.0% confidence
	1.4421e+06 +/- 116231
	120.098% +/- 9.67969%
	(Student's t, pooled s = 79695.4)
#   5       2285282       2569064       2391433     2387326.4     113448.11
Difference at 95.0% confidence
	1.18655e+06 +/- 117000
	98.8156% +/- 9.74369%
	(Student's t, pooled s = 80222.4)
@   5       1921940       2130368       2007542     2024337.4     87207.233
Difference at 95.0% confidence
	823563 +/- 89939.3
	68.586% +/- 7.49011%
	(Student's t, pooled s = 61668)
O   5       1460995       1846963       1577575     1593754.2     156411.63
Difference at 95.0% confidence
	392980 +/- 161306
	32.7272% +/- 13.4335%
	(Student's t, pooled s = 110602)
```
