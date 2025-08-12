Impact of enabling firewalls on BSDRP 1.90 (FreeBSD 11.2-BETA3) forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled
  - Traffic load at 14.88 Mpps

![Impact of D27401 on forwarding performance](graph.png)

IPv4:
```
x r368287: inet packets-per-second forwarded
+ r368287 with D27401(diff 80345): inet packets-per-second forwarded
* r368606: inet packets-per-second forwarded
% r368606 with D27401(diff 80654): inet packets-per-second forwarded
# r368606 with D27401(diff 80677): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                    # %   |
|*       *      * *  xx*  x xx        +  + + + +     #       #  #  % # %  %|
|                     |__AM__|                                             |
|                                      |__AM__|                            |
|    |_______A__M_____|                                                    |
|                                                                   |__A_| |
|                                                        |_____AM_____|    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3071185       3144171       3114676       3107360     32851.687
+   5       3219891       3303938       3266067     3264808.2     32932.106
Difference at 95.0% confidence
	157448 +/- 47971
	5.06694% +/- 1.58328%
	(Student's t, pooled s = 32891.9)
*   5       2882413       3086748       3018123     2995591.8      78810.25
Difference at 95.0% confidence
	-111768 +/- 88053.5
	-3.59689% +/- 2.81885%
	(Student's t, pooled s = 60375)
%   5       3493187       3556366       3527924     3526414.2     22431.051
Difference at 95.0% confidence
	419054 +/- 41023.3
	13.4859% +/- 1.44401%
	(Student's t, pooled s = 28128.1)
#   5       3365051       3512846       3465153     3456929.2     60612.471
Difference at 95.0% confidence
	349569 +/- 71098.9
	11.2497% +/- 2.349%
	(Student's t, pooled s = 48749.9)
```

IPv6:
```
x r368287: inet6 packets-per-second forwarded
+ r368287 with D27401(diff 80345): inet6 packets-per-second forwarded
* r368606: inet6 packets-per-second forwarded
% r368606 with D27401(diff 80654): inet6 packets-per-second forwarded
# r368606 with D27401(diff 80677): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|* *            *     *  #  x# O  #x%   x+ %%    #  +  #   +          +   +|
|                          |_____A_M___|                                   |
|                                             |____________A____________|  |
| |____________AM__________|                                               |
|                                |________AM_______|                       |
|                         |_______M___A____________|                       |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3761355       3869973       3832557     3815913.6     43624.956
+   5       3872229       4109730       4000345     4002730.8     95695.279
Difference at 95.0% confidence
	186817 +/- 108459
	4.89574% +/- 2.86671%
	(Student's t, pooled s = 74366.4)
*   5       3589974       3800966       3699635     3687868.2     89146.609
Difference at 95.0% confidence
	-128045 +/- 102352
	-3.35556% +/- 2.6651%
	(Student's t, pooled s = 70179.3)
%   5       3804216       3975640       3887207     3881016.4     65287.857
No difference proven at 95.0% confidence
#   5       3762679       3971463       3825888     3855442.8     90646.992
No difference proven at 95.0% confidence
```

Flamegraphs:
- [r368287: inet4](bench.r368287.inet4.svg)
- [r368287 with D27401(diff 80345): inet4](bench.r368287D27401v2.inet4.svg)
- [r368606: inet4](bench.r368606.inet4.svg)
- [r368606 with D27401(diff 80654): inet4](bench.r368606D27401v3.inet4.svg)
- [r368606 with D27401(diff 80677): inet4](bench.r368606D27401v4.inet4.svg)
- [r368287: inet6](bench.r368287.inet6.svg)
- [r368287 with D27401(diff 80345): inet6](bench.r368287D27401v2.inet6.svg)
- [r368606: inet6](bench.r368606.inet6.svg)
- [r368606 with D27401(diff 80654): inet6](bench.r368606D27401v3.inet6.svg)
- [r368606 with D27401(diff 80677): inet6](bench.r368606D27401v4.inet6.svg)
