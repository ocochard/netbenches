Impact of disabling icmp redirect (ie re-enabling fastforward) on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)

```
x net.inet.ip.redirect=1 (default): Number of inet4 packets-per-second forwarded
+ net.inet.ip.redirect=0: Number of inet4 pps forwarded
+--------------------------------------------------------------------------+
|x                                                                        +|
|xx                                                                      ++|
|xx                                                                      ++|
|MA                                                                        |
|                                                                        |A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     2199966.5       2309062       2210097     2230250.6     45711.484
+   5       8211578     8259515.5       8244041     8235045.2      20946.73
Difference at 95.0% confidence
        6.00479e+06 +/- 51854.8
        269.243% +/- 7.86461%
        (Student's t, pooled s = 35554.9)
```
