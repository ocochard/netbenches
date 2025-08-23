# Impact of icmp_drop_redirect on forwarding performance

Lab:
  - [SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)](https://www.supermicro.com/en/products/system/1U/5018/SYS-5018A-FTN4.cfm)
  - Dual port Intel X520 82599ES
  - FreeBSD 15-head n302432
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - iflib.tx_abdicate=1
  - iflib.override_ntxds=1024 (was 2048 by default)
  - iflib.override_nrxds=1024 (was 2048 by default)

# Results

### Ministat

Unit: Packets-per-second forwarded

```
x off (default)
+ on
+--------------------------------------------------------------------------+
|*                  +  ++                         x        x   *x          |
|                    |_________________________A___________M______________||
|   |__________________M__A______________________|                         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4629365       4741411     4732260.5     4711932.9     47186.873
+   5       4630225     4740342.5     4667793.5     4674331.8     40291.557
No difference proven at 95.0% confidence
```
