Impact of enabling ALTQ kernel option on inet4 forwarding performance

```
x 11-stable r332393: inet4 packets-per-second forwarded
+ 11-stable r332393 with ALTQ: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+ x         x+    x                  +             +   +           x     x|
| |________________M_______________A________________________________|      |
|       |_______________________A_____M_________________|                  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3601297       4442303       3784031     3982493.4     392887.23
+   5       3574507       4226896       4015296     3945897.8     286346.82
No difference proven at 95.0% confidence
```
