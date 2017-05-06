Impact of adding VIMAGE support on forwarding/ipfw/pf performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 12-head r317849
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps

![Impact of adding VIMAGE support on forwarding/ipfw/pf performance](graph.png)


forwarding performance is not impacted:
```
x r317849 forwarding (packets-per-seconds)
+ r317849 with VIMAGE forwarding (packets-per-seconds)
+--------------------------------------------------------------------------+
|+                                                         + x             |
|+ x                                                      x* x+            |
|                      |________________________A__________M______________||
|   |_______________________________A______________________M_________|     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4253914       5841132       5795473     5500184.2     697340.33
+   5       4202061     5857939.5       5779047     5166715.1     880796.85
No difference proven at 95.0% confidence
```

ipfw performance is not impacted:

```
x r317849 ipfw-statefull (packets-per-seconds)
+ r317849 with VIMAGE ipfw-statefull (packets-per-seconds)
+--------------------------------------------------------------------------+
|                                                       +                  |
|x                                                      + xx*+x+           |
|                     |_________________________A__________M______________||
|                                                       |__AM_|            |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3714690       4849309     4785555.5     4585845.5     487961.77
+   5       4732090       4859987       4808019     4796060.9     56816.915
No difference proven at 95.0% confidence
```

pf performance is not impacted:

```
x r317849 pf-statefull (packets-per-seconds)
+ r317849 with VIMAGE.pf-statefull (packets-per-seconds)
+--------------------------------------------------------------------------+
|* +                                              +    *  xx    + x        |
|                     |_________________________A_________M_______________||
|    |_____________________________A______________M______________|         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2570798     3163639.5       3087873     2997438.3     241219.38
+   5       2566864       3150281       3018248     2877634.8      277976.7
No difference proven at 95.0% confidence
```

flame graph:
   - [r317849 and forwarding](bench.317849.forwarding.svg)
   - [r317849 and ipfw-statefull](bench.317849.ipfw-statefull.svg)
   - [r317849 and pf-statefull](bench.317849.pf-statefull.svg)
   - [r317849 with VIMAGE and forwarding](bench.317849VIMAGE.forwarding.svg)
   - [r317849 with VIMAGE and ipfw-statefull](bench.317849VIMAGE.ipfw-statefull.svg)
   - [r317849 with VIMAGE and pf-statefull](bench.317849VIMAGE.pf-statefull.svg)

They were generated with this command:
```
stackcollapse-pmc.pl bench.312905.1.pmc.graph | flamegraph.pl > bench.312905.svg

```
