Impact of Chelsio rx/tx queue number on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 10.2
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - ntxq10g and nrxq10g = 1 to 8 (with 8=number of core=default on this setup)
  - Traffic load at 10 Mpps

![Impact of Chelsio rx/tx queue number on forwarding performance on FreeBSD 10.2](graph.png)


```
x pps.1
+ pps.2
* pps.3
% pps.4
# pps.5
@ pps.6
O pps.8
+--------------------------------------------------------------------------+
|  O                                                                       |
|  O     O                                                                 |
|xxO     O                +@@+@+ @ @ *#O*  ##           %           %  %%  |
|AM                                                                        |
|                         |MA_|                                            |
|                                    MA_|                                  |
|                                                            |_____A___M__||
|                                      |__AM|                              |
|                          |__MA__|                                        |
| |M__A__|                                                                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1189795       1200125       1199682     1197806.6     4489.3479
+   5       1682173       1778483       1707862     1722035.2      38103.63
Difference at 95.0% confidence
        524229 +/- 39567.1
        43.7657% +/- 3.3033%
        (Student's t, pooled s = 27129.7)
*   5       1898512       1967253       1904508     1921583.4     28928.916
Difference at 95.0% confidence
        723777 +/- 30190.8
        60.4252% +/- 2.5205%
        (Student's t, pooled s = 20700.7)
%   5       2269851       2580742       2565039       2497548     131048.89
Difference at 95.0% confidence
        1.29974e+06 +/- 135227
        108.51% +/- 11.2895%
        (Student's t, pooled s = 92719.9)
#   5       1927777       2039046       2016438     1988804.4     55691.796
Difference at 95.0% confidence
        790998 +/- 57619.8
        66.0372% +/- 4.81045%
        (Student's t, pooled s = 39507.8)
@   5       1697397       1866248       1760286     1771394.2     69218.478
Difference at 95.0% confidence
        573588 +/- 71533.2
        47.8865% +/- 5.97202%
        (Student's t, pooled s = 49047.7)
O   5       1219407       1355429       1235417       1279208     67639.331
Difference at 95.0% confidence
        81401.4 +/- 69908.2
        6.79587% +/- 5.83635%
        (Student's t, pooled s = 47933.5)
```
