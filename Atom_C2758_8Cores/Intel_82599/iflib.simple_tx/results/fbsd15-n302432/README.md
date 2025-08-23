# Impact of iflib.simple_tx vs tx_abdicate on forwarding performance

Lab:
  - [SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)](https://www.supermicro.com/en/products/system/1U/5018/SYS-5018A-FTN4.cfm)
  - Dual port Intel X520 82599ES
  - FreeBSD 15-head n302432
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - iflib.override_ntxds=1024 (was 2048 by default)
  - iflib.override_nrxds=1024 (was 2048 by default)

Impact of:
  - iflib.simple_tx
  - iflib.tx_abdicate

# Results

### Ministat

Unit: Packets-per-second forwarded

```
x tx_abdicate=0 and simple_tx=0 (default)
+ tx_abdicate=1
* simple_tx=1
+--------------------------------------------------------------------------+
|  *x                                                                  +   |
|**** xx                                                               +  +|
|   MA|                                                                    |
|                                                                     |MA| |
||AM|                                                                      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     3555322.5     3603300.5       3564885     3575148.1     22334.317
+   5       4663174     4714342.5       4668850     4676436.7     21409.441
Difference at 95.0% confidence
	1.10129e+06 +/- 31906
	30.804% +/- 1.04477%
	(Student's t, pooled s = 21876.8)
*   5       3510856     3556499.5       3539270     3534777.7     18564.033
Difference at 95.0% confidence
	-40370.4 +/- 29950.4
	-1.1292% +/- 0.832157%
	(Student's t, pooled s = 20535.9)
```
