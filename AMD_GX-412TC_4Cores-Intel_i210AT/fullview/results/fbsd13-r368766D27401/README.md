Impact of D27401 on forwarding performance with a full-view
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
  - netstat -rn4 | wc -l : 712793
  - netstat -rn6 | wc -l : 104034

System displaying this message during route table loading:
```
[rt_algo] inet6.0 (radix6_lockless) rebuild_callout: switching algo to radix6
[rt_algo] inet.0 (bsearch4) rebuild_callout: switching algo to radix4
```

IPv4:
```
x r368766: inet packets-per-second forwarded
+ r368766 with D27401v80909: inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|    +                                                                     |
|+   + +      +                               x                x xx       x|
|                                                    |_________A_M_______| |
| |__MA____|                                                               |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        733210        742776        739784      738987.6     3521.4544
+   5        717408      721952.5        718895      719284.3     1662.3472
Difference at 95.0% confidence
	-19703.3 +/- 4015.89
	-2.66626% +/- 0.531612%
	(Student's t, pooled s = 2753.55)
```

IPv6:

```
x r368766: inet6 packets-per-second forwarded
+ r368766 with D27401v80909: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|      +                                                          x   x    |
|+     + ++                                                       x   x   x|
|                                                                 |__AM__| |
|  |___A__|                                                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        757463        766052        761435      761071.8     3483.2349
+   5        689963        699848        696562      696077.4     3744.1708
Difference at 95.0% confidence
	-64994.4 +/- 5273.81
	-8.53985% +/- 0.666145%
	(Student's t, pooled s = 3616.06)
```
