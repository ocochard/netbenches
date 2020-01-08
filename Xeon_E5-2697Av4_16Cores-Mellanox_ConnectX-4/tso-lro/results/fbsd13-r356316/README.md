Impact of TSO & LRO on forwarding performance.
Packets-per-second forwarded:

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

=> huge improvement by disabling this on inet4

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

=> No impact on inet6... something wrong

Flamegraphs:
- [enabled (default) inet4] (bench.enabled-default.inet4.pmc.svg)
- [enabled (default) inet6] (bench.enabled-default.inet6.pmc.svg)
- [disabled inet4] (bench.disabled.inet4.pmc.svg)
- [disabled inet6] (bench.disabled.inet6.pmc.svg)
