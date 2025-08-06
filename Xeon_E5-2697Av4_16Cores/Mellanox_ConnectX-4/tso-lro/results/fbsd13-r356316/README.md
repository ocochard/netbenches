Impact of TSO & LRO on (UDP only packets) forwarding performance.
Hypothesis: LRO and TSO features shouldn't have any impact on UDP packets.

Setup a forwarding lab:
```
+---------+   +---------+   +---------+
| netmap  |   |         |   | netmap  |
| pkt-gen |   |   DUT   |   | pkt-gen |
|generator|   |         |   |receiver |
|     cxl0|->-|mce0 cxl1|->-|cxl0     |
|         |   |         |   |         |
+---------+   +---------+   +---------+
```
Data:
  * Generator is sending 5000 flows of smallest UDP packet at 40Mpps rate.
  * DUT is configured as forwarding device.
  * Receiver is measuring receiving rate.
  * 2 configurations set: One with default (LRO and TSO enabled) and second with `-tso4 -tso6 -lro -vlanhwtso` set on all NICs

Packets-per-second forwarded difference with inet4:
```
x enabled (default): inet4
+ disabled: inet4
+--------------------------------------------------------------------------+
|                                                                        ++|
|xxxxx                                                                  +++|
||_A_|                                                                     |
|                                                                        A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      27463046      27724202      27568318      27599181     109278.63
+   5      32355798      32463268      32416758      32414376     47287.862
Difference at 95.0% confidence
	4.8152e+06 +/- 122795
	17.4469% +/- 0.511089%
	(Student's t, pooled s = 84196.1)
```

=> huge improvement by disabling theses features on inet4 !?! How TSO/LRO impact UDP only traffic ?

Packets-per-second forwarded difference with inet6:
```
x enabled (default): inet6
+ disabled: inet6
+--------------------------------------------------------------------------+
|               +         x                                                |
|               +         xx                                               |
|              ++         xx                                              +|
|                         A|                                               |
||______________M__________A_________________________|                     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      28064201      28107933      28082922      28085502     18654.875
+   5      27600773      30203451      27614966      28130116     1159047.6
No difference proven at 95.0% confidence
```

=> No impact with inet6 UDP packets ???... something wrong

Flamegraphs:
* inet4
  * [enabled (default) inet4](bench.enabled-default.inet4.pmc.svg)
  * [disabled inet4](bench.disabled.inet4.pmc.svg)
* inet6
  * [enabled (default) inet6](bench.enabled-default.inet6.pmc.svg)
  * [disabled inet6](bench.disabled.inet6.pmc.svg)
