```
x 511-default.pps
+ 351.pps
+--------------------------------------------------------------------------+
|                                                           * +            |
|x                                                       x  *x++           |
|                     |_________________________A___________M_____________||
|                                                           |AM|           |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2789621       2828304       2827404     2819676.8     16839.103
+   5       2827277       2829177     2828692.5     2828371.9     796.69053
No difference proven at 95.0% confidence
```

FreeBSD 11.1 vs 11.1-yandex:

```
x ../fbsd11.1/351.pps
+ 351.pps
+--------------------------------------------------------------------------+
|+       +           +  +   +            x     x      x     x             x|
|                                          |__________MA____________|      |
|    |___________A___M______|                                              |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2830101     2832423.5       2831026     2831104.3     898.56299
+   5       2827277       2829177     2828692.5     2828371.9     796.69053
Difference at 95.0% confidence
	-2732.4 +/- 1238.44
	-0.0965136% +/- 0.0437206%
	(Student's t, pooled s = 849.156)
```