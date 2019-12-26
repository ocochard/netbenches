Comparing benefit of patch D3737 on forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 11-head r287478 with D3737
  - 2000 flows of smallest UDP packets
  - ntxq10g and nrxq10g = 4 (and not the default value of ncpu=8)
  - Traffic load at 10Mpps

![Comparing benefit of patch D3737 on forwarding performance](graph.png)

Same performance (at 95% confidence) with D3737 and fastforwarding mode:

```
x pps.forwarding (D3737 patched)
+ ../fbsd11-head.r287478/pps.fastforwarding
+--------------------------------------------------------------------------+
|      +                                                                   |
|      +   +            xx                        +     x x   +           x|
|                        |_____________________A________M____________|     |
||_________M________________A_________________________|                    |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       2601689       2955440       2830444     2767939.6     155317.64
+   5       2481219       2871388       2513895     2627509.2     187778.93
No difference proven at 95.0% confidence

```
