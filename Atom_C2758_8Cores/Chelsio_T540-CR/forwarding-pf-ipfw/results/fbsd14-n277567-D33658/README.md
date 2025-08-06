# Impact of D33658 (Pre-calculate L2 prepends for routes with gateway and avoid arp/nd lookup) on forwarding performance

lab:
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - FreeBSD 14-head n277567 (2020/08/20)
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled
  - 2000 UDP flows
  - Traffic load at 14.88 Mpps

# Results

## ministat

### inet

```
x n277567: packets-per-second forwarded
+ n277567 with D33658: packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                              +           |
|x x    x  x       x                                           ++     +   +|
||______A______|                                                           |
|                                                             |_M__A____|  |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       5412642       5620939     5489556.5     5496573.1     82094.054
+   5       6130165     6256993.5       6136242     6174366.1     58401.818
Difference at 95.0% confidence
        677793 +/- 103899
        12.3312% +/- 2.04798%
        (Student's t, pooled s = 71239.8)
```

### inet6

```
x n277567: packets-per-second forwarded
+ n277567 with D33658: packets-per-second forwarded
+--------------------------------------------------------------------------+
|+    x    +         +   +            xx  x           +                   x|
|               |______________________MA_______________________|          |
| |__________________MA___________________|                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4831899.5     5095989.5       4962476     4963931.2     93581.295
+   5       4813940       5019418     4891574.5     4896448.5     77592.329
No difference proven at 95.0% confidence
```

## flamegraph

### inet

  - [n277567](bench.n277567.inet4.pmc.svg)
  - [n277567 with D33658](bench.n277567D33658.inet4.pmc.svg)

## inet6

  - [n277567](bench.n277567.inet6.pmc.svg)
  - [n277567 with D33658](bench.n277567D33658.inet6.pmc.svg)
