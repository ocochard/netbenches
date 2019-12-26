Impact of having IPSec option into the kernel:

```
x r329155 GENERIC-NODEBUG: inet4 packets-per-second
+ r329155 GENERIC-NODEBUG + nooptions IPSEC + nooptions IPSEC_SUPPORT: inet4 pps
+--------------------------------------------------------------------------+
|                                      +                                   |
|+  +          x                     x +  x     x           +             x|
|                     |___________________MA____________________|          |
|  |_________________________A_________M______________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       5782474       5922519       5845401     5849070.2     50582.803
+   5       5748413       5889057       5838726     5814324.5     60322.353
No difference proven at 95.0% confidence
```

With a Yandex patched now:

```
x r329155 YANDEX: inet4 packets-per-second
+ r329155 YANDEX + nooptions IPSEC + nooptions IPSEC_SUPPORT: inet4 pps
+--------------------------------------------------------------------------+
|x+                xx   xx                         +        ++   +         |
|       |_________A_M______|                                               |
|                     |_________________________A___________M_____________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      10499543      10588586      10567862      10560772     35610.422
+   5      10504656      10736823      10717161      10672732     95761.085
Difference at 95.0% confidence
	111961 +/- 105363
	1.06016% +/- 0.998976%
	(Student's t, pooled s = 72243.6)
```
