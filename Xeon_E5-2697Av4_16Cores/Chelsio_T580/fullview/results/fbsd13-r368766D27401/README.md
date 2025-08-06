Comparing D27401 impact on forwarding performance:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - RX NIC (heavy work): Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - TX NIC: Mellanox_ConnectX-4
  - Increase number of Chelsio RX & TX queues to 32
  - 5000 flows of smallest UDP packets
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - ICMP redirect disabled
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
+ r368766 with D27401 (diff 80909): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|x          +   x                           +  x  +      +   x         x  +|
|        |_____________________________A_______M_____________________|     |
|                       |______________________A__M___________________|    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      22038877      22848942      22571194      22479436        345147
+   5      22160599      22878299      22598881      22571368     263149.44
No difference proven at 95.0% confidence
```

IPv6:
```
x r368766: inet6 packets-per-second forwarded
+ r368766 with D27401 (diff 80909): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x                                      +x     ++    x        x+    +     x|
|                 |___________________________A______M____________________||
|                                         |_____M____A___________|         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      20487636      21612439      21292374      21184055     432007.98
+   5      21095496      21528903      21212991      21295658     181812.74
No difference proven at 95.0% confidence
```

Flamegraphs:
- [r368766: inet4](bench.r368766.inet4.pmc.svg)
- [r368766 with D27401 (diff 80909): inet4](bench.r368766D27401v80909.inet4.pmc.svg)
- [r368766: inet6](bench.r368766.inet6.pmc.svg)
- [r368766 with D27401 (diff 80909): inet6](bench.r368766D27401v80909.inet6.pmc.svg)
