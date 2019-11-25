```
inet4 packets-per-second-forwarded:
x net.isr.maxthreads=1 (default)
+ net.isr.maxthreads="-1" (using all core)
+--------------------------------------------------------------------------+
|+                                                    *  x +xx++           |
|                                                      |__A_M|             |
|                    |__________________________A__________M______________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        786116        794772      793169.5      791657.9     3708.1872
+   5        723392        796895        792345      779047.4     31345.716
No difference proven at 95.0% confidence
```
