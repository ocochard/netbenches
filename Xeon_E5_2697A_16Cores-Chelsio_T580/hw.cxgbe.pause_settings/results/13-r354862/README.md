Impact of disabling icmp redirect (ie re-enabling fastforward) on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)
  - hw.cxgbe.nrxq="32
  - machdep.hyperthreading_intr_allowed="1"

```
x hw.cxgbe.pause_settings=0 (default): Number of inet4 packets-per-second forwarded
+ hw.cxgbe.pause_settings=1: Number of inet4 pps forwarded
+--------------------------------------------------------------------------+
|x                           +  x   +  +    + x         +                 x|
|         |_____________________M____A_________________________|           |
|                              |_______M_A_________|                       |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      24440254      24536843      24481016      24487790      35015.44
+   5      24477223      24513195      24490633      24493013     13385.716
No difference proven at 95.0% confidence
```
