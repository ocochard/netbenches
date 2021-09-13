# Impact of kernel option KDTRACE_HOOKS on forwarding performance

Setup:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - Input NIC: Mellanox ConnectX-4 MCX416A-CCAT (100GBase-SR4)
  - Output NIC: Chelsio T580 (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD main n268373 (13/09/2021)
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - Generator rate: 43.68Mpps
  - ICMP redirect disabled

# ministat

```
x main n268373: inet packets-per-second forwarded
+ main n268373 "nooptions KDTRACE_HOOKS": inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|+x          xx x                                        ++  ++            |
|     |_____A_M__|                                                         |
|                     |_________________________A_________M_______________||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      30927630      31090123      31071220      31043471     65901.286
+   5      30919058      31625372      31577360      31460090      303541.6
Difference at 95.0% confidence
	416619 +/- 320327
	1.34205% +/- 1.03249%
	(Student's t, pooled s = 219637)
```
