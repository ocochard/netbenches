# Impact of IPSEC_SUPPORT vs IPSEC in kernel config
Lab:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - Input NIC: Mellanox ConnectX-4 MCX416A-CCAT (100GBase-SR4)
  - Output NIC: Chelsio T580 (QSFP+ 40GBASE-SR4)
  - FreeBSD 14-head n277887
  - Minimum firewall rules
  - HyperThreading and LRO/TSO disabled
  - harvest.mask=351
  - Traffic generator: 42Mpps of smallest UDP packet size

# Results

Slight reduction with inet6 (shouldn't be related).

## ministat

### inet

```
x n277887 with IPSEC_SUPPORT: inet packets-per-second forwarded
+ n277887 with IPSEC: inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|  x         x x             +                      +    +    x   +    +  x|
||_____________M_________________A________________________________|        |
|                                      |_______________A_M_____________|   |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      29128937      29843913      29255900      29437277     323915.17
+   5      29393063      29815696      29671292      29654295     164267.82
No difference proven at 95.0% confidence
```

### inet6

```
x n277887 with IPSEC_SUPPORT: inet6 packets-per-second forwarded
+ n277887 with IPSEC: inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|   +                                                                      |
| + +     +       +            x x          x           x                 x|
|                             |_____________M___A________________|         |
||__M___A_____|                                                            |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      28322056      29038046      28544251      28602965     294528.76
+   5      27851274      28113568      27883878      27942539     107207.16
Difference at 95.0% confidence
        -660426 +/- 323236
        -2.30894% +/- 1.10707%
        (Student's t, pooled s = 221631)
```
## flamegraph

### inet

  - [n277887 with IPSEC_SUPPORT](bench.n277887GENERIC.inet4.1.pmc.svg)
  - [n277887 with IPSEC](bench.n277887IPSEC.inet4.1.pmc.svg)

## inet6

  - [n277887 with IPSEC_SUPPORT](bench.n277887GENERIC.inet6.1.pmc.svg)
  - [n277887 with IPSEC](bench.n277887IPSEC.inet6.1.pmc.svg)
