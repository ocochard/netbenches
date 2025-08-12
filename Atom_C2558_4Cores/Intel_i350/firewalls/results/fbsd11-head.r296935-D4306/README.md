Comparing benefit of patch [D4306] (https://reviews.freebsd.org/D4306) on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11 head r296935
  - 2 static routing tables
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)


Same performance (at 95% confidence) with D4306 and forwarding mode:
```
x 296935.forwarding (pps)
+ 296935 with D4306.forwarding (pps)
+--------------------------------------------------------------------------+
|                    +                                                     |
|x                  ++ +       x      x  xx *+xx*  x    +   +             +|
|                        |_____________A___M__________|                    |
|                     |__________________A___M______________|              |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        800606        834942      829670.5        826794     9947.0735
+  10      813802.5        850769        830590     828233.25     13112.847
No difference proven at 95.0% confidence

```

About -1% with pf enabled:
```
x 296935.pf-statefull (pps)
+ 296935 with D4306.pf-statefull (pps)
+--------------------------------------------------------------------------+
|               x                                 +                        |
|x              x x xx x   x +       + +  +  x    +  +       +  +         +|
|        |_________MA__________|                                           |
|                                   |_____________A____________|           |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        403815        413590        407758     408048.85     2448.3863
+  10        409983        419864      414593.5      414543.7     3006.1989
Difference at 95.0% confidence
        6494.85 +/- 2575.92
        1.59168% +/- 0.631277%
        (Student's t, pooled s = 2741.52)
```


About -1% with ipfw enabled:

```
x 296935.ipfw-statefull (pps)
+ 296935 with D4306.ipfw-statefull (pps)
+--------------------------------------------------------------------------+
|                       x x                +                               |
|x       +x      x    * x x      x         + ++      +   +   +   x        +|
|       |_______________MA________________|                                |
|                          |_________________AM_________________|          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        513848        533651      521031.5     521150.25     5206.8535
+  10        516169        536370      527619.5     527524.35     5790.8748
Difference at 95.0% confidence
        6374.1 +/- 5173.99
        1.22308% +/- 0.992802%
        (Student's t, pooled s = 5506.61)
```
