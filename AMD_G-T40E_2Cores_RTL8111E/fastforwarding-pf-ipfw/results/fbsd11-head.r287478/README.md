Impact of enabling ipfw/pf on fastforwarding performance
  - PC Engines APU (dual core AMD G-T40E Processor 1 GHz)
  - 3 Realtek RTL8111E Gigabit Ethernet ports
  - FreeBSD 11 head r287478
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of enabling ipfw/pf on fastforwarding performance on FreeBSD 11 head r287478](graph.png)


```
x pps.fastforwarding
+ pps.ipfw-statefull
* pps.pf-statefull
+--------------------------------------------------------------------------+
|*                                                                         |
|*      +                                                                 x|
|*      ++                                                              x x|
|**     ++                                                              x x|
|                                                                       |AM|
|       A|                                                                 |
|A|                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        138090        139420        139120      138776.8     625.74532
+   5         91107         92194         91631       91722.4      449.0265
Difference at 95.0% confidence
	-47054.4 +/- 794.27
	-33.9065% +/- 0.572336%
	(Student's t, pooled s = 544.602)
*   5         86311         86791         86553       86530.2     200.80513
Difference at 95.0% confidence
	-52246.6 +/- 677.729
	-37.6479% +/- 0.488359%
	(Student's t, pooled s = 464.693)
```
