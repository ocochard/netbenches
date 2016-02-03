Impact of glebius'mbuf not inlined" patch and ipfw/pf on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Gigabit Intel i350
  - FreeBSD 11-295150
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

Conclusion: No impact with this setup.

On forwarding:
```
x 295150.forwarding
+ 295150mbuf.forwarding
+--------------------------------------------------------------------------+
|x                       + + x+   x   x  x +   * x     + x    + +      +  +|
|                    |_______________A_M____________|                      |
|                               |_________________AM________________|      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        759894        799074      786496.5     784665.55     10682.117
+  10        776807        810792      794576.5      793926.6     12650.294
No difference proven at 95.0% confidence
```

On pf impact on forwarding:
```
x 295150.pf-statefull
+ 295150mbuf.pf-statefull
+--------------------------------------------------------------------------+
|                                  +                                       |
| *x x        x x   x *       x+   +         x      ++    + ++            x|
||________________M____A_____________________|                             |
|                    |___________________A__M_______________|              |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        401991        412598     404310.75     405069.75     3294.6571
+  10        401911        410739        408083      407679.9     2879.9957
No difference proven at 95.0% confidence
```

On ipfw impact on forwarding:
```
x 295150.ipfw-statefull
+ 295150mbuf.ipfw-statefull
+--------------------------------------------------------------------------+
|                                                +                         |
|x  x   +  +      *      x  +++       x  x   x   +    x x +x              +|
|            |____________________A_____M______________|                   |
|             |______________M_____A_____________________|                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        494532      506637.5        502553      501409.8     4413.2095
+  10        496003        509683      500425.5      501666.4     4468.8114
No difference proven at 95.0% confidence
```
