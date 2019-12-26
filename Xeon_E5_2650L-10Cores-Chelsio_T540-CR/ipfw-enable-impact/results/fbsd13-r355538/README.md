Impact of enabling ipfw in standard and in nic-level mode
```
x forwarding: inet4 packets-per-second forwarded
+ ipfw-standard: inet4 packets-per-second forwarded
* ipfw-at-nic-level: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|        + *                                                               |
|**    +*+ *  +                                                 x  x x   xx|
|                                                                |___A___| |
|   |___AM___|                                                             |
| |___A_M__|                                                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       8507686       8837456     8653213.5     8679951.1     140182.01
+   5       6390081       6810472       6620237     6604775.1     151696.63
Difference at 95.0% confidence
	-2.07518e+06 +/- 213010
	-23.9077% +/- 2.20329%
	(Student's t, pooled s = 146053)
*   5       6365005       6701309       6593245     6548169.6     162617.51
Difference at 95.0% confidence
	-2.13178e+06 +/- 221413
	-24.5598% +/- 2.3047%
	(Student's t, pooled s = 151815)
```
