Impact of glebius'mbuf not inlined" patch [https://reviews.freebsd.org/D5180] (D5180) and ipfw/pf on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Gigabit Intel i350
  - FreeBSD 11-295150
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

This is the second run of a previous bench: Checking bench methodology for consistent results.
[../fbsd11-head.r295150.mbuf/README.md] (First run benches results)

Synthesis of difference at 95.0% confidence:
  - forwarding: No difference proven (same as first run)
  - pf impact of forwarding: (same as first run)
  - ipfw impact of forwarding: (same as first run)


On forwarding:
```
x 295150.forwarding
+ 295150mbuf.forwarding
+--------------------------------------------------------------------------+
|  x                      +                    x                           |
|+ x   +   x  +x        xx+  +      +         xx        x  +    +         +|
|       |_______________M___A___________________|                          |
|        |_________________M______A_______________________|                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        762926      798773.5        777527     779758.25     13384.927
+  10        761768        810767        779547     783628.65      16564.35
No difference proven at 95.0% confidence
```

On pf impact on forwarding:
```
x 295150.pf-statefull
+ 295150mbuf.pf-statefull
+--------------------------------------------------------------------------+
|                        x                    +                            |
|x      x         +   +  x x+x x x+           *  +     x   +    +         +|
|           |_______________A_______________|                              |
|                         |_________________A_M_______________|            |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        398693        410524      404520.5      404590.6     3449.5786
+  10        402489        414640     408563.75     408077.45     4020.3462
No difference proven at 95.0% confidence
```

On ipfw impact on forwarding:
```
x 295150.ipfw-statefull
+ 295150mbuf.ipfw-statefull
+--------------------------------------------------------------------------+
|+           x   +x+**    x *                 +*x +  x     x              +|
|               |__________M_____A________________|                        |
|          |_____________M______A_____________________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        495001        508957      499143.5      501149.1     5063.8124
+  10        491434      513430.5     498605.75      500887.4     6423.9581
No difference proven at 95.0% confidence
```
