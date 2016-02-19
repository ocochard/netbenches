Comparing impact of patch D5330 on forwarding performance (and pf/ipfw impact)
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 10-stable r295802 with D5330 patch
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

This patch, on this setup, reduce forwarding performance by -9% (+/- 1%):
```
x 295802.forwarding
+ 295802 with D5330.forwarding
+--------------------------------------------------------------------------+
|    +       ++                                    x            x          |
|++ ++       +++                                   x x    x  xx x x       x|
|                                                    |______AM______|      |
|  |_____A____|                                                            |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        667496        694785        679868      678624.1     8549.9547
+  10        608019        624612        617817     617255.35     6681.9961
Difference at 95.0% confidence
        -61368.8 +/- 7209.55
        -9.04311% +/- 1.06238%
        (Student's t, pooled s = 7673.03)
```

Same for ipfw:
```
x 295802.ipfw-statefull
+ 295802 with D5330.ipfw-statefull
+--------------------------------------------------------------------------+
| +  +  +                                         x                        |
|+++ ++ +     +                                 x xxx x x  x              x|
|                                              |___M__A_______|            |
| |__A___|                                                                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        429187        453498      432157.5      434994.3     7239.6462
+  10        384593        396428        388293     388681.35      3589.626
Difference at 95.0% confidence
        -46313 +/- 5368.78
        -10.6468% +/- 1.23422%
        (Student's t, pooled s = 5713.93)
```

Same for pf:
```
x 295802.pf-statefull
+ 295802 with D5330.pf-statefull
+--------------------------------------------------------------------------+
|              + +                                                x        |
|++ ++   +  +  + +                                         x  x xxx x xx  x|
|                                                             |___MA___|   |
|  |______A_____|                                                          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        373450        383293     378091.75        378338     2965.5897
+  10        334176        344736        340372      339975.5     4173.0098
Difference at 95.0% confidence
        -38362.5 +/- 3401.33
        -10.1397% +/- 0.899019%
        (Student's t, pooled s = 3620)
```
