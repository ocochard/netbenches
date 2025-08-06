Impact of disabling icmp redirect (ie re-enabling fastforward) on forwarding performance
  - Intel Xeon CPU E5-2697A v4 @ 2.60GHz (16c, 32t)
  - Chelsio 40-Gigabit T580-LP-CR (QSFP+ 40GBASE-SR4 (MPO 1x12 Parallel Optic))
  - FreeBSD 13-HEAD r354862 (19/11/2019)
  - 5000 flows of smallest UDP packets (1 byte payload)

```
x no affinity (default): Number of inet4 packets-per-second forwarded
+ affinity: Number of inet4 pps forwarded
+--------------------------------------------------------------------------+
|                                                                    +     |
|x                           +       x x  *x                        ++     |
|              |________________A______M__________|                        |
|                                    |_________________A____________M_____||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      23944132      24536725      24472436      24383384     247811.19
+   5      24335726      24893001      24888990      24705846      262215.6
No difference proven at 95.0% confidence
```
