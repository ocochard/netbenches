Impact of pf states_hashsize with 100K states
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR
  - FreeBSD 12.0-CURRENT r336223
  - 50K unidirection flows of smallest UDP packets (So 100K in pf states table)
  - 2 static routes
  - Traffic load at 14.88 Mpps

![Impact of states_hashsize with 100K states](graph.png)


Best benefit with states_hashsize increased from 32K to 256K (+9.5%):
```
x states_hashsize=32768 (default): Inet 4 packets-per-second forwarded
+ states_hashsize=262144: Inet 4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|x  x  xx   x                                  +               +    ++   + |
| |___AM___|                                                               |
|                                                     |_________A___M_____||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       1438188       1465039     1453002.5     1450940.7     10273.292
+   5     1549098.5     1610723.5     1598767.5     1589461.5     23994.738
Difference at 95.0% confidence
        138521 +/- 26917.8
        9.54696% +/- 1.88372%
        (Student's t, pooled s = 18456.5)
```
