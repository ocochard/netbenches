Benching impact of D27428 (Enable ROUTE_MPATH support in GENERIC kernels)
IPv4:
```
x r368200: inet4 packets-per-second forwarded
+ r368200 with D27428: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                           +                              |
|+                                       ++ +                      xx x x x|
|                                                                  |__A__| |
|               |_________________A_______M__________|                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     9803502.5     9843579.5       9822232     9822433.6     15632.275
+   5       9449022       9682297       9670171     9629134.8     100921.96
Difference at 95.0% confidence
	-193299 +/- 105319
	-1.96793% +/- 1.07174%
	(Student's t, pooled s = 72213.6)
```

IPv6:

```
x r368200: inet6 packets-per-second forwarded
+ r368200 with D27428: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                           +                                          x   |
|+                          + + +                                  x   xx x|
|                                                                   |__A__||
|          |____________A___M________|                                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      12290746      12332178      12316458      12314907     15029.942
+   5      11923735      12098864      12075520      12051498     72063.829
Difference at 95.0% confidence
	-263408 +/- 75916.8
	-2.13894% +/- 0.615918%
	(Student's t, pooled s = 52053.3)
```

Notice the huge difference between IPv4 and IPv6 forwarding speed.
So lets just compare inet vs inet6:

```
x r368200: inet4 packets-per-second forwarded
+ r368200: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                         +|
| x                                                                       +|
|xx                                                                       +|
|xx                                                                      ++|
||A                                                                        |
|                                                                        |A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     9803502.5     9843579.5       9822232     9822433.6     15632.275
+   5      12290746      12332178      12316458      12314907     15029.942
Difference at 95.0% confidence
	2.49247e+06 +/- 22363.9
	25.3753% +/- 0.259315%
	(Student's t, pooled s = 15334.1)
```

=> forwarding IPv6 is 25% faster than IPv4 !!

inet vs inet6 on D27428:

```
x r368200 with D27428: inet4 packets-per-second forwarded
+ r368200 with D27428: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|      x                                                                 + |
|      x                                                                 + |
|      x                                                                 + |
|x     x                                                             +   + |
|  |__AM_|                                                                 |
|                                                                     |_AM||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9449022       9682297       9670171     9629134.8     100921.96
+   5      11923735      12098864      12075520      12051498     72063.829
Difference at 95.0% confidence
	2.42236e+06 +/- 127888
	25.1566% +/- 1.55746%
	(Student's t, pooled s = 87688.2)
```

=> Still 25% diff with D27428 applied
