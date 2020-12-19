Impact of D27401 and D27412 on forwarding performance with a full-view
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - 2 static routes
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled
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
| +               x                                                     ** |
|+++ +       x    xx x                                             *    ** |
|              |__A__|                                                     |
||A_|                                                                      |
|                                                                    |__A_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        733210        742776        739784      738987.6     3521.4544
+   5        717408      721952.5        718895      719284.3     1662.3472
Difference at 95.0% confidence
	-19703.3 +/- 4015.89
	-2.66626% +/- 0.531612%
	(Student's t, pooled s = 2753.55)
*   5        802228        810211        808250      807658.2      3198.992
Difference at 95.0% confidence
	68670.6 +/- 4906.33
	9.29252% +/- 0.698403%
	(Student's t, pooled s = 3364.09)
```

IPv6:

```
x r368766: inet6 packets-per-second forwarded
+ r368766 with D27401 (diff 80909): inet6 packets-per-second forwarded
* r368766 with D27401 (80909) and D27412 (80866): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                                                         *|
|+   ++++                                           x  x  x    * **       *|
|                                                   |__A_|                 |
|  |__A_|                                                                  |
|                                                              |__M_A____| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        757463        766052        761435      761071.8     3483.2349
+   5        689963        699848        696562      696077.4     3744.1708
Difference at 95.0% confidence
	-64994.4 +/- 5273.81
	-8.53985% +/- 0.666145%
	(Student's t, pooled s = 3616.06)
*   5        772103        786976        776178      779441.8     6806.6457
Difference at 95.0% confidence
	18370 +/- 7885.26
	2.4137% +/- 1.04131%
	(Student's t, pooled s = 5406.63)
```
