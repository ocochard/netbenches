Impact of pf counter(9) patches
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - Input NIC: Mellanox ConnectX-4 MCX416A-CCAT (100GBase-SR4)
  - Output NIC: Chelsio T580 (QSFP+ 40GBASE-SR4)
  - FreeBSD 13 main 1622a498525 2020/12/23
  - Minimum firewall rules
  - 2 static routes
  - 5000 flows of smallest UDP packets at 43.68 Mpps
  - HyperThreading and LRO/TSO disabled
  - harvest.mask=351

```
x FreeBSD 13 main 1622a498525: inet packets-per-second firewalled
+ FreeBSD 13 main 1622a498525 with pf patches: inet packets-per-second firewalled
+--------------------------------------------------------------------------+
|                                                                        + |
| xx                                                                     + |
|xxx                                                                    +++|
||A|                                                                       |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9216962       9526356       9343902     9371057.6     116720.36
+   5      19427190      19698400      19502922      19546509     109084.92
Difference at 95.0% confidence
	1.01755e+07 +/- 164756
	108.584% +/- 2.9359%
	(Student's t, pooled s = 112967)
```

Flamegraphs
- [Before](nflx.20201223.svg)
- [After](nflx.20201223PFpatch.svg)
