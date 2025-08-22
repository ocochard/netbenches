# Impact of iflib.tx_abdicate on forwarding performance

Lab:
  - [Aoostar WTR MAX (8 cores x 2 threads AMD Ryzen 7 PRO 8845HS at 3.8GHz)](https://aoostar.com/products/aoostar-wtr-max-amd-r7-pro-8845hs-11-bays-mini-pc)
  - Intel X710
  - FreeBSD 15-head n302145 (e69573bc2be)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0

Testing:
  - dev.ixl.X.iflib.tx_abdicate

# Results

## ministat

Unit: packets-per-second forwarded

```
x dev.ixl.X. iflib.tx_abdicate=0 (default)off_default.pps
+ dev.ixl.X.iflib.tx_abdicate=on
+--------------------------------------------------------------------------+
|x                                                                    ++   |
|x                                                                    ++  +|
|A                                                                         |
|                                                                     |A_| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       7174479     7174540.5       7174517     7174515.5     23.205603
+   5      11944804      12197345      11979026      12014689     104085.61
Difference at 95.0% confidence
	4.84017e+06 +/- 107341
	67.4634% +/- 1.49614%
	(Student's t, pooled s = 73599.6)
```

## flamegraphs

### inet

  - [tx_abdicate=0](bench.off_default.1.pmc.svg)
  - [tx_abdicate=1](bench.on.1.pmc.svg)
