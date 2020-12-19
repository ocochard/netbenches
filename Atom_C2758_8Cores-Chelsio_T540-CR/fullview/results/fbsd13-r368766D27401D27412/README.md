Impact of D27401 and D27412 on forwarding performance with a full-view
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled
  - Traffic load at 14.88 Mpps
  - FreeBSD r368766
  - [script used to generate full-view](https://github.com/ocochard/BSDRP/blob/master/BSDRP/Files/usr/local/bin/bgptabledump2bird)
  - kld_list="dpdk_lpm4 dpdk_lpm6"
  - netstat -rn4 | wc -l : 712793
  - netstat -rn6 | wc -l : 104034

System displaying this message during route table loading:
```
[rt_algo] fib_module_register: attaching dpdk_lpm4 to inet
[rt_algo] fib_module_register: attaching dpdk_lpm6 to inet6
[rt_algo] inet6.0 (radix6_lockless) rebuild_callout: switching algo to dpdk_lpm6
[rt_algo] inet.0 (bsearch4) rebuild_callout: switching algo to dpdk_lpm4
```

IPv4:
```
x r368766: inet packets-per-second forwarded
+ r368766 with D27401 (80909): inet packets-per-second forwarded
* r368766 with D27401 (80909) and D27412 (80866): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                       * *|
|+    + x++x x+x                                                        ***|
|        |_MA_|                                                            |
|  |____AM___|                                                             |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2616815       2699557       2655672       2660459     30502.708
+   5       2535157       2692514       2626806     2617476.4     59238.452
No difference proven at 95.0% confidence
*   5       3374235       3400491       3392290       3388222     12494.831
Difference at 95.0% confidence
	727763 +/- 33993.5
	27.3548% +/- 1.58179%
	(Student's t, pooled s = 23308.1)
```

IPv6:
```
x r368766: inet6 packets-per-second forwarded
+ r368766 with D27401 (diff 80909): inet6 packets-per-second forwarded
* r368766 with D27401 (80909) and D27412 (80866): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
| ++ ++     x   +x x  x                                        ** * *     *|
|           |___AM___|                                                     |
||___MA_____|                                                              |
|                                                              |__MA___|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3088878       3222444       3162892       3149159     57752.053
+   5       2961467       3138679       2991535     3013423.2     71870.228
Difference at 95.0% confidence
	-135736 +/- 95082.3
	-4.31022% +/- 2.96891%
	(Student's t, pooled s = 65194.4)
*   5       3783006       3926721       3813570       3832847      58606.28
Difference at 95.0% confidence
	683688 +/- 84853.3
	21.7102% +/- 2.99697%
	(Student's t, pooled s = 58180.7)
```

Flamegraphs:
- [r368766 with D27401 and D27412: inet4](bench.r368766D27401D27412.inet4.pmc.svg)
- [r368766 with D27401 and D27412: inet6](bench.r368766D27401D27412.inet6.pmc.svg)
