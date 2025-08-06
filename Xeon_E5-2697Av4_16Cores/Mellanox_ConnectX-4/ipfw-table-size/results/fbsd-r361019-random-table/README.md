Testing IPFW performance impact regarding size (number of IP) of a blacklist table
Notice: This table was generated using randomized IP address.
```
x 1 entry, inet4 packets-per-second forwarded
+ 1K entries, inet4 packets-per-second forwarded
* 10K entries, inet4 packets-per-second forwarded
% 100K entries, inet4 packets-per-second forwarded
# 500K entries, inet4 packets-per-second forwarded
@ 1M entries, inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|@ O#@   O#  #@%%    %O * **    + +++     +                       x     xx |
|                                                                   |__AM_||
|                               |__MA__|                                   |
|                      |_AM|                                               |
|               |__A_M|                                                    |
|   |___AM__|                                                              |
||___MA____|                                                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      27319623      27684231      27668987      27599228     156845.19
+   5      25424956      25984130      25582525      25630627      213819.8
Difference at 95.0% confidence
	-1.9686e+06 +/- 273471
	-7.13281% +/- 0.966728%
	(Student's t, pooled s = 187509)
*   5      24875072      25136860      25111292      25052538      110395.6
Difference at 95.0% confidence
	-2.54669e+06 +/- 197799
	-9.2274% +/- 0.673182%
	(Student's t, pooled s = 135624)
%   5      24467739      24854316      24849441      24717999     186980.84
Difference at 95.0% confidence
	-2.88123e+06 +/- 251686
	-10.4395% +/- 0.873871%
	(Student's t, pooled s = 172572)
#   5      23846449      24357276      24186552      24089952     225836.64
Difference at 95.0% confidence
	-3.50928e+06 +/- 283558
	-12.7151% +/- 0.986806%
	(Student's t, pooled s = 194426)
@   5      23717504      24423578      23958720      24014448     280333.82
Difference at 95.0% confidence
	-3.58478e+06 +/- 331274
	-12.9887% +/- 1.16503%
	(Student's t, pooled s = 227143)
```
