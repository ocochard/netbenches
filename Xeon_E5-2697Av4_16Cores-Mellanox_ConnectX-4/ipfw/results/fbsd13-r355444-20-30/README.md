DDoS: 20Mpps legitimate, 30Mpps DDoS (50Mpps total)
```
x ipfw-standard.pps
+ ipfw-at-nic-level.pps
+--------------------------------------------------------------------------+
|xxxx                                                         +      + +++ |
||A|                                                                       |
|                                                                |___A_M__||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11096198      11291682      11144450      11171039     83430.495
+   5      15564181      16382780      16252228      16109634      330757.3
Difference at 95.0% confidence
	4.9386e+06 +/- 351786
	44.2089% +/- 3.24918%
	(Student's t, pooled s = 241206)
```