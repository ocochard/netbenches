Impact of Intel 82599EB queue number on forwarding performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
  - FreeBSD 11-head.project/routing 287531
  - 2000 flows of smallest UDP packets
  - Traffic load at 14.48Mpps (10Gigabit line-rate)

![Impact of Intel 82599EB queue number on forwarding performance on FreeBSD 11-routing.r287478](graph.png)


```
x pps.1
+ pps.2
* pps.3
% pps.4
+--------------------------------------------------------------------------+
|                                                       *                % |
|xx                                  ++                 *                %%|
|xx                                  ++     *           **               %%|
|AM                                                                        |
|                                    AM                                    |
|                                               |_____A_M__|               |
|                                                                        A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        759319        774855        773124      768447.2     7349.3996
+   4       1481953       1500378       1499909     1493592.5     8632.4591
Difference at 95.0% confidence
        725145 +/- 12572.6
        94.365% +/- 1.6361%
        (Student's t, pooled s = 7924.76)
*   5       1630229       1882969       1872658     1825125.2     109183.68
Difference at 95.0% confidence
        1.05668e+06 +/- 112853
        137.508% +/- 14.6859%
        (Student's t, pooled s = 77379.2)
%   5       2216223       2235495       2222283     2224568.4     7995.6165
Difference at 95.0% confidence
        1.45612e+06 +/- 11199.8
        189.489% +/- 1.45746%
        (Student's t, pooled s = 7679.31)

```
