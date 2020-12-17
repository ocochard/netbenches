Comparing D27401 impact on forwarding performance:
  - HP ProLiant DL360p Gen8 with 8 cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 13-head r368606
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled

![Impact of D27401 on forwarding performance](graph.png)

IPv4:
```
x r368287: inet packets-per-second forwarded
+ r368287 with D27401(diff 80345): inet packets-per-second forwarded
* r368606: inet packets-per-second forwarded
% r368606 with D27401(diff 80654): inet packets-per-second forwarded
# r368606 with D27401(diff 80677): inet packets-per-second forwarded
+--------------------------------------------------------------------------+
|%                       #     # %  #x+#  #++ +**   *   *  x *      x     x|
|                                           |______________A_____________| |
|                                       |___MA____|                        |
|                                              |____MA_____|               |
|         |____________A_M_________|                                       |
|                           |_____A_M____|                                 |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14816846      14817302      14817116      14817115     174.22399
+   5      14816864      14817034      14816937      14816944     62.114411
No difference proven at 95.0% confidence
*   5      14816971      14817148      14817036      14817045     71.202528
No difference proven at 95.0% confidence
%   5      14816412      14816799      14816706      14816678     154.51602
Difference at 95.0% confidence
	-437.2 +/- 240.155
	-0.00295064% +/- 0.00162077%
	(Student's t, pooled s = 164.665)
#   5      14816700      14816912      14816836      14816819     84.052365
Difference at 95.0% confidence
	-295.6 +/- 199.489
	-0.00199499% +/- 0.00134632%
	(Student's t, pooled s = 136.782)
```

IPv6:

```
x r368287: inet6 packets-per-second forwarded
+ r368287 with D27401(diff 80345): inet6 packets-per-second forwarded
* r368606: inet6 packets-per-second forwarded
% r368606 with D27401(diff 80654): inet6 packets-per-second forwarded
# r368606 with D27401(diff 80677): inet6 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+                 +   %      %  %*+   ** +O # %%  #      x x*   xx  #x#  *|
|                                                          |____AM___|     |
|         |_________________A______M__________|                            |
|                               |_______M_________A________________|       |
|                        |_______M__A__________|                           |
|                                          |_______M____A____________|     |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14472818      14472916      14472876      14472864     39.524676
+   5      14472344      14472690      14472629      14472568     147.50017
Difference at 95.0% confidence
	-296.2 +/- 157.48
	-0.00204659% +/- 0.0010881%
	(Student's t, pooled s = 107.978)
*   5      14472615      14472948      14472667      14472746      142.7876
No difference proven at 95.0% confidence
%   5      14472528      14472736      14472610      14472637     91.023074
Difference at 95.0% confidence
	-227 +/- 102.338
	-0.00156845% +/- 0.000707098%
	(Student's t, pooled s = 70.1691)
#   5      14472689      14472922      14472757      14472797      109.2909
No difference proven at 95.0% confidence
```

Flamegraphs:
- [r368287: inet4](bench.r368287.inet4.svg)
- [r368287 with D27401(diff 80345): inet4](bench.r368287D27401v2.inet4.svg)
- [r368606: inet4](bench.r368606.inet4.svg)
- [r368606 with D27401(diff 80654): inet4](bench.r368606D27401v3.inet4.svg)
- [r368606 with D27401(diff 80677): inet4](bench.r368606D27401v4.inet4.svg)
- [r368287: inet6](bench.r368287.inet6.svg)
- [r368287 with D27401(diff 80345): inet6](bench.r368287D27401v2.inet6.svg)
- [r368606: inet6](bench.r368606.inet6.svg)
- [r368606 with D27401(diff 80654): inet6](bench.r368606D27401v3.inet6.svg)
- [r368606 with D27401(diff 80677): inet6](bench.r368606D27401v4.inet6.svg)
