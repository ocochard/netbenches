Impact of random.harvest.mask and Chelsio rx/tx queue number on fastforwarding performance
  - HP ProLiant DL360p Gen8 with eight cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 11-routing.r287531
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - ntxq10g and nrxq10g = 1, 2, 3, 4, 5, 6, 7 and 8 (=number of core=default on this setup)
  - Traffic load at 10 Mpps

![Impact of random.harvest.mask=351 and Chelsio rx/tx queue number on forwarding performance on FreeBSD 11-routing.r287531](graph.png)


```
x pps.1
+ pps.2
* pps.3
% pps.4
# pps.5
@ pps.6
O pps.8
+--------------------------------------------------------------------------+
|x           +**           #      @ %                                    OO|
|x           +**          ##     @@ %                                  O OO|
|A                                                                         |
|            A                                                             |
|             |A                                                           |
|                                   A                                      |
|                         |A                                               |
|                                |A                                        |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1421886       1426447       1422556       1423267     1872.7122
+   5       2797335       2816630       2806057     2807739.2     7775.4306
Difference at 95.0% confidence
	1.38447e+06 +/- 8247.9
	97.2742% +/- 0.579505%
	(Student's t, pooled s = 5655.28)
*   5       2940941       2971852       2960042       2957430     14881.186
Difference at 95.0% confidence
	1.53416e+06 +/- 15467.6
	107.792% +/- 1.08677%
	(Student's t, pooled s = 10605.6)
%   5       5375864       5405343       5392692       5389120     11908.044
Difference at 95.0% confidence
	3.96585e+06 +/- 12431.4
	278.644% +/- 0.873441%
	(Student's t, pooled s = 8523.75)
#   5       4297966       4360845       4310479     4322747.2     25118.379
Difference at 95.0% confidence
	2.89948e+06 +/- 25975.8
	203.72% +/- 1.82509%
	(Student's t, pooled s = 17810.7)
@   5       5089932       5179138       5109107       5120803     34207.899
Difference at 95.0% confidence
	3.69754e+06 +/- 35330.6
	259.792% +/- 2.48236%
	(Student's t, pooled s = 24224.9)
O   5       9329260       9667146       9539065     9539810.2     134987.98
Difference at 95.0% confidence
	8.11654e+06 +/- 139223
	570.276% +/- 9.78194%
	(Student's t, pooled s = 95460.1)
```
