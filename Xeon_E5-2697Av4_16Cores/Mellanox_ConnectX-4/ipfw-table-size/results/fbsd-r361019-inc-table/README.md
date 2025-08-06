BAD Bench! (educationnal purpose only)
Testing IPFW performance impact regarding size (number of IP) of a blacklist table
Notice: This table was generated using incremented IP, so the RADIX lookup
efficiency made this a wrong bench.
```
x 1.pps
+ 500K.pps
* 1M.pps
+--------------------------------------------------------------------------+
|+ x      *+            +           x  +*     x       *   * * x           x|
|                |__________________________A_M_________________________|  |
|   |___________________M__A_______________________|                       |
|                      |____________________A_________M__________|         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      27496592      27778262      27666484      27660338     108292.25
+   5      27488096      27724319      27579459      27591587     93283.548
No difference proven at 95.0% confidence
*   5      27522017      27723920      27696780      27660124     83044.776
No difference proven at 95.0% confidence
```
