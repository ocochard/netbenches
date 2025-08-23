# Impact of harvest.mask on forwarding performance

Lab:
  - [SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)](https://www.supermicro.com/en/products/system/1U/5018/SYS-5018A-FTN4.cfm)
  - Dual port Intel X520 82599ES
  - FreeBSD 15-head n302432
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - iflib.tx_abdicate=1
  - iflib.override_ntxds=1024 (was 2048 by default)
  - iflib.override_nrxds=1024 (was 2048 by default)

# Results

### Ministat

```
x 4607_default.pps
+ 4479.pps
+--------------------------------------------------------------------------+
|x                    +          +  + +         x  x        x   +         x|
|                  |___________________________A___M______________________||
|                      |____________M__A______________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4587101.5       4746873       4697360     4687503.9     60317.314
+   5       4633839       4726744     4663379.5     4669793.9     34437.919
No difference proven at 95.0% confidence
```
