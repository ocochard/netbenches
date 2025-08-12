Comparing D27428 impact on forwarding performance:

IPv4:
```
x r368200: inet packets-per-second forwarded
+ r368200 with D27428: inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+                               xxx    +                +        + +      |
|                                |A                                        |
|                  |__________________________A__________M________________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      744726.5        749883        747013      747129.5     2330.0344
+   5      659212.5        839278        809395      781445.1     74499.772
No difference proven at 95.0% confidence
```

IPv6:

```
x r368200: inet6 packets-per-second forwarded
+ r368200 with D27428: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|     x                                                               +    |
|x   xxx                                                          +   ++  +|
|  |_AM|                                                                   |
|                                                                  |__A__| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        782058        787152        786122      785496.4     2020.3858
+   5        838593        845423        842332      842153.2     2424.7243
Difference at 95.0% confidence
	56656.8 +/- 3254.85
	7.21287% +/- 0.426869%
	(Student's t, pooled s = 2231.73)
```

=> 7% difference with inet6 ??

Let's check the forwarding diff between inet and inet6 first:

```
x r368200: inet packets-per-second forwarded
+ r368200: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x                                                                       + |
|x   x  x x                                                      +     +++ |
||___A___|                                                                 |
|                                                                  |___AM_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      744726.5        749883        747013      747129.5     2330.0344
+   5        782058        787152        786122      785496.4     2020.3858
Difference at 95.0% confidence
	38366.9 +/- 3180.44
	5.13524% +/- 0.4383%
	(Student's t, pooled s = 2180.71)
```

=> On a standard r368200, there is already 5% diff between inet and inet6

```
x r368200 with D27428: inet packets-per-second forwarded
+ r368200 with D27428: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                    +     |
|                                                                    +     |
|x                                      x                x        x *++    |
|                  |__________________________A__________M________________||
|                                                                   |A|    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      659212.5        839278        809395      781445.1     74499.772
+   5        838593        845423        842332      842153.2     2424.7243
No difference proven at 95.0% confidence
```

=> On patched, no more difference?
