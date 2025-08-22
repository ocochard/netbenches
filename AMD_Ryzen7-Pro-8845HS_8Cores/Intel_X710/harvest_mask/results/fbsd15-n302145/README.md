# Impact of kern.random.harvest.mask on forwarding performance

Lab:
  - [Aoostar WTR MAX (8 cores x 2 threads AMD Ryzen 7 PRO 8845HS at 3.8GHz)](https://aoostar.com/products/aoostar-wtr-max-amd-r7-pro-8845hs-11-bays-mini-pc)
  - Intel X710
  - FreeBSD 15-head n302145 (e69573bc2be)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0

Testing:
  - kern.random.harvest.mask

Previous FreeBSD releases were using INTERRUPT and ETHERNET as entropy source, creating
some locking contention and reducing throughput at high packet rate.
NET_ETHERNET is no more enabled by default, but INTERRUPT is still, what about
removing it ?

Default:
```
kern.random.harvest.mask_symbolic: PURE_RDRAND,RANDOMDEV,[CALLOUT],[UMA],[FS_ATIME],SWI,INTERRUPT,NET_NG,[NET_ETHER],NET_TUN,MOUSE,KEYBOARD,ATTACH,CACHED
kern.random.harvest.mask_bin: 00000000000100001000101011111
kern.random.harvest.mask: 135647
```

Tuned (removing INTERRUPT):
```
kern.random.harvest.mask_symbolic: PURE_RDRAND,RANDOMDEV,[CALLOUT],[UMA],[FS_ATIME],SWI,[INTERRUPT],NET_NG,[NET_ETHER],NET_TUN,MOUSE,KEYBOARD,ATTACH,CACHED
kern.random.harvest.mask_bin: 00000000000100001000101011111
kern.random.harvest.mask: 135519
```

# Results

## ministat

Unit: packets-per-second forwarded

### IPv4

```
x kern.random.harvest.mask=4607 (default)
+ kern.random.harvest.mask=4479
+--------------------------------------------------------------------------+
|        + x x  + *+x                                                     +|
|           |___A_M_|                                                      |
||________________M________A__________________________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11896556      11966731      11950128      11937531     31938.248
+   5      11881892      12401105      11947549      12025676     212005.59
No difference proven at 95.0% confidence
```

### IPv6

```
x kern.random.harvest.mask=4607 (default)
+ kern.random.harvest.mask=4479
+--------------------------------------------------------------------------+
|          ++      ++    x           x                 x        x         +|
|                       |____________M___A_________________|               |
||_________________M_______A__________________________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11784726      11814942      11794461      11797456     13596.151
+   5      11774447      11822799      11780536      11786735     20405.738
No difference proven at 95.0% confidence
```
