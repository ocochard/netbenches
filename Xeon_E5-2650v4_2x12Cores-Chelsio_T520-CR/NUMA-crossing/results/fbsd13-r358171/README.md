Number of packets-per-second forwarded:
x Same NUMA domain: Input (Chelsio port0 , domain 1) and output (Chelsio port1, domain 1)
+ Crossing NUMA domain: Input (Chelsio port0, domain 1) and output (Mellanox port0, domain 0)
+--------------------------------------------------------------------------+
| +                                                                       x|
|++                                                                       x|
|++                                                                       x|
|                                                                         A|
||A                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14206025      14213520      14209153      14209177     3062.2352
+   5       7894033     7972144.5       7944430     7939979.1     30916.891
Difference at 95.0% confidence
	-6.2692e+06 +/- 32039.8
	-44.1208% +/- 0.224732%
	(Student's t, pooled s = 21968.5)
