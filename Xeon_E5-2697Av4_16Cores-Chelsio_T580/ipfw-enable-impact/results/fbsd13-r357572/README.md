```
x forwarding.pps
+ ipfw-standard.pps
* ipfw-at-nic-level.pps
+--------------------------------------------------------------------------+
| +               * *                                                    x |
|++++             ***                                                  x xx|
|                                                                       |A||
||A|                                                                       |
|                 |A|                                                      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      27967317      28368906      28273492      28225063     155040.18
+   5      19155212      19485510      19263378      19311494     135234.83
Difference at 95.0% confidence
	-8.91357e+06 +/- 212167
	-31.5803% +/- 0.627989%
	(Student's t, pooled s = 145475)
*   5      21316273      21538326      21468002      21429176     105989.98
Difference at 95.0% confidence
	-6.79589e+06 +/- 193680
	-24.0775% +/- 0.578744%
	(Student's t, pooled s = 132799)
```

Flamegraphs:
  - [forwarding](bench.forwarding.1.pmc.svg)
  - [ipfw standard](bench.ipfw-standard.1.pmc.svg)
  - [ipfw-at-nic-level](bench.ipfw-at-nic-level.1.pmc.svg)
