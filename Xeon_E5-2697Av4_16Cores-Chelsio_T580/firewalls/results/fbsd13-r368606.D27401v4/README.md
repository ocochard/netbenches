Comparing D27401 (Diff 80654) impact on forwarding performance:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - RX NIC (heavy work): Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - TX NIC: Mellanox_ConnectX-4
  - Increase number of Chelsio RX & TX queues to 32
  - FreeBSD 13-head r368606
  - 5000 flows of smallest UDP packets
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - ICMP redirect disabled

IPv4:
```
x r368606: inet packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+  +   +      +        +                                 x    x  x  x    x|
|                                                           |_____A_____|  |
||______M_A________|                                                       |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      31964087      31979331      31971433      31971814     5761.5606
+   5      31911429      31932540      31918297      31920122     8490.4582
Difference at 95.0% confidence
	-51692.4 +/- 10581.7
	-0.161681% +/- 0.03308%
	(Student's t, pooled s = 7255.46)
```

=> No difference here

IPv6:
```
x r368606: inet6 packets-per-second forwarded
+ r368606 with D27401 (Diff 80677): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x                                   +  xx   x     + +             x    + +|
|              |_______________________A_M_____________________|           |
|                                         |__________M___A_______________| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      31080364      31088281      31085165      31084898     2855.3236
+   5      31084717      31089077      31086549      31087097     1851.0781
No difference proven at 95.0% confidence
```

=> No difference here

Flamegraphs:
- [r368287: inet4](bench.r368606.inet4.pmc.svg)
- [r368287: inet6](bench.r368606.inet6.pmc.svg)
- [r368287 with D27401: inet4](bench.r368606D27401v4.inet4.pmc.svg)
- [r368287 with D27401: inet6](bench.r368606D27401v4.inet6.pmc.svg)
