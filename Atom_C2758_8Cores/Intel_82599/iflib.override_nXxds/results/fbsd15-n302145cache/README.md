# Impact of number of descriptors on forwarding performance
Lab:
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Dual port Intel Intel 82599
  - FreeBSD 15-head (e69573bc2be, August 2025)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 12 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

# Results

For this use case, reducing descriptors is improving performance.

### inet

Value of dev.ix.X.iflib.override_n(t|r)xd
```
x 1024: IPv4 packet-per-seconds forwarded
+ 2046 (default): IPv4 packet-per-seconds forwarded
* 4096: IPv4 packet-per-seconds forwarded
+--------------------------------------------------------------------------+
|* *+*     **    +  +        +    +                          x      xx  x x|
|                                                               |____A____||
|        |__________MA__________|                                          |
||___MA____|                                                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4757048.5       4816851       4795555     4793453.7     22741.459
+   5     4494548.5       4633284       4567313     4570769.5      53376.64
Difference at 95.0% confidence
	-222684 +/- 59833.8
	-4.64559% +/- 1.23951%
	(Student's t, pooled s = 41025.8)
*   5       4479961     4531158.5       4496116     4504464.5     22508.308
Difference at 95.0% confidence
	-288989 +/- 32997.5
	-6.02883% +/- 0.667745%
	(Student's t, pooled s = 22625.2)
```
