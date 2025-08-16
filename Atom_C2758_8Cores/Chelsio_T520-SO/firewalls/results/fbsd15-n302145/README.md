# Impact of firewalls on forwarding performance
Lab:
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Chelsio T520-SO
  - FreeBSD 15-head n302145 (e69573bc2be)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.8 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0

# Results

## Graph

![Impact of firewalls on forwarding performance](graph.png)

## flamegraphs

### inet

  - [forwarding: inet](bench.forwarding.inet4.svg)
  - [ipfw-stateless: inet](bench.ipfw-stateless.inet4.svg)
  - [ipfw-stateful: inet](bench.ipfw-stateful.inet4.svg)
  - [pf-stateful: inet](bench.pf-stateful.inet4.svg)
  - [pf-stateless: inet](bench.pf-stateless.inet4.svg)
  - [ipf-stateless: inet](bench.ipf-stateless.inet4.svg)
  - [ipf-stateful: inet](bench.ipf-stateful.inet4.svg)

## inet6

  - [forwarding: inet6](bench.forwarding.inet6.svg)
  - [ipfw-stateless: inet6](bench.ipfw-stateless.inet6.svg)
  - [ipfw-stateful: inet6](bench.ipfw-stateful.inet6.svg)
  - [pf-stateless: inet6](bench.pf-stateless.inet6.svg)
  - [pf-stateful: inet6](bench.pf-stateful.inet6.svg)
  - [ipf-stateless: inet6](bench.ipf-stateful.inet6.svg)
  - [ipf-stateful: inet6](bench.ipf-stateless.inet6.svg)

## ministat

### firewalls

Unit: packets-per-second forwarded
```
x forwarding.inet4.pps
+ ipfw-stateless.inet4.pps
* ipfw-stateful.inet4.pps
% pf-stateless.inet4.pps
# pf-stateful.inet4.pps
@ ipf-stateless.inet4.pps
O ipf-stateful.inet4.pps
+--------------------------------------------------------------------------+
|O                                                                         |
|O     @                                                                   |
|O     @     %   #                    *           +                        |
|O     @     %  ##                    *          ++                        |
|O     @@   %%  ##                    *          ++          x x      x x x|
|                                                             |_____A_M___||
|                                                |A                        |
|                                     A|                                   |
|            A                                                             |
|               |A                                                         |
|      A|                                                                  |
|A                                                                         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4915543.5       5867096       5591154     5432378.7     409435.96
+   5       4099762       4181736     4134222.5     4139204.3     36830.338
Difference at 95.0% confidence
	-1.29317e+06 +/- 423946
	-23.8049% +/- 5.96352%
	(Student's t, pooled s = 290684)
*   5       3266597       3326455     3321802.5     3303489.1     29291.449
Difference at 95.0% confidence
	-2.12889e+06 +/- 423320
	-39.1889% +/- 4.75924%
	(Student's t, pooled s = 290255)
%   5     1466439.5       1488377       1487517       1480721     10069.711
Difference at 95.0% confidence
	-3.95166e+06 +/- 422369
	-72.7427% +/- 2.12723%
	(Student's t, pooled s = 289602)
#   5       1739745       1791010     1755894.5     1758838.4     19385.872
Difference at 95.0% confidence
	-3.67354e+06 +/- 422714
	-67.6231% +/- 2.54332%
	(Student's t, pooled s = 289839)
@   5       1099092       1114290       1101357     1104875.6     6406.6789
Difference at 95.0% confidence
	-4.3275e+06 +/- 422293
	-79.6613% +/- 1.58553%
	(Student's t, pooled s = 289550)
O   5        644601        668597      655209.5      656647.1     10417.841
Difference at 95.0% confidence
	-4.77573e+06 +/- 422378
	-87.9123% +/- 0.960123%
	(Student's t, pooled s = 289609)
```

### inet vs inet6

Unit: packets-per-second forwarded

```
x forwarding.inet4.pps
+ forwarding.inet6.pps
+--------------------------------------------------------------------------+
|+                   + + x +   +  x                         x    x        x|
|                              |____________________A_______M____________| |
|        |___________A_M________|                                          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4915543.5       5867096       5591154     5432378.7     409435.96
+   5       4440170     5023437.5       4874362     4823728.9     226254.57
Difference at 95.0% confidence
	-608650 +/- 482422
	-11.2041% +/- 8.12918%
	(Student's t, pooled s = 330779)
```
