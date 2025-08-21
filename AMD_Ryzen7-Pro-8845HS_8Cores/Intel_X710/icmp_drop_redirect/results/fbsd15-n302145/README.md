# Impact of icmp_drop_redirect on forwarding performance

Lab:
  - Aoostar WTR MAX (8 cores x 2 threads AMD Ryzen 7 PRO 8845HS at 3.8GHz)
  - Intel X710
  - FreeBSD 15-head n302145 (e69573bc2be)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0

Testing:
  - icmp_drop_redirect

# Results

## ministat

Unit: packets-per-second forwarded

```
x off_default
+ on
+--------------------------------------------------------------------------+
|x    x+      +           +         x        x    x+                      +|
|    |______________________A_______M_____________|                        |
|      |__________________M_______A___________________________|            |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11927874      11961504      11951560      11946070     15375.247
+   5      11932024      11977640      11944976      11950681     18836.952
No difference proven at 95.0% confidence
```
