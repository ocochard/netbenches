Impact of enabling fastforwarding/ipfw/pf on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-routing.r287531
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of enabling fastforwarding/ipfw/pf on forwarding performance on FreeBSD 11-routing.r287531](graph.png)


```
x pps.forwarding
+ pps.fastforwarding
* pps.ipfw-statefull
% pps.pf-statefull
+--------------------------------------------------------------------------+
|%                                                                         |
|%                                                                         |
|%                 *                                                       |
|%             x   **                                                  +  +|
|%            xx   **                                                  ++ +|
|             |A                                                           |
|                                                                      |MA||
|                  MA                                                      |
|A                                                                         |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5        587344        598788        594469      593951.8     4209.5568
+   5       1127598       1153428       1137833     1139961.8     12325.635
Difference at 95.0% confidence
        546010 +/- 13432
        91.9283% +/- 2.26146%
        (Student's t, pooled s = 9209.82)
*   5        634518        644624        636178      637783.8     4163.9644
Difference at 95.0% confidence
        43832 +/- 6106.24
        7.37972% +/- 1.02807%
        (Student's t, pooled s = 4186.82)
%   5        462489        466145        463964        463944      1489.564
Difference at 95.0% confidence
        -130008 +/- 4604.98
        -21.8886% +/- 0.775312%
        (Student's t, pooled s = 3157.46)

```
