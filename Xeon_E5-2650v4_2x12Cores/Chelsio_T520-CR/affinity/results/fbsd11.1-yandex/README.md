Impact of binding interrupt to core on forwarding performance
  - Dell PowerEdge R630 with 2 Intel Xeon CPU E5-2650 v4 (2 packages x 12 cores x 2 hardware threads)
  - Quad port Chelsio 10-Gigabit T520-CR plugged on numa-domain 1
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX lock) patches
  - 2000 flows of smallest UDP packets
  - HT disabled
  - harvest.mask=351
  - Chelsio number of queue=12

Configuration sets:
  - no-affinity: default value, no cxl's queues interrupt binding
  - affinity-numa0: All 12 cxl's queue interrupt bind to core0-11
  - affinity-numa1: All 12 cxl's queues interrupt bind to core12-23

```
x no-affinity: inet4 packet-per-seconds
+ affinity-numa0: inet4 packet-per-seconds
* affinity-numa1: inet4 packet-per-seconds
+--------------------------------------------------------------------------+
|                 +x                                                   *   |
|+      x     x + +x+                                                 ** **|
|          |____A__M_|                                                     |
|      |_______A__M____|                                                   |
|                                                                     |MA_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9351036       9580847       9571249       9510859     98839.328
+   5       9220385       9603697       9557225     9493098.6      154964.3
No difference proven at 95.0% confidence
*   5      10584085      10670945      10617361      10629374     35170.165
Difference at 95.0% confidence
        1.11851e+06 +/- 108191
        11.7604% +/- 1.25701%
        (Student's t, pooled s = 74182.7)
```
