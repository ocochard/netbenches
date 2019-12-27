Impact of binding interrupt to core on forwarding performance
  - Dell PowerEdge R630 with 2 Intel Xeon CPU E5-2650 v4 (2 packages x 12 cores x 2 hardware threads)
  - Quad port Chelsio 10-Gigabit T520-CR plugged on numa-domain 1
  - FreeBSD 12 -head r327075 with Yandex (AFDATA and RADIX lock) patches
  - 2000 flows of smallest UDP packets
  - HT disabled
  - harvest.mask=351
  - Chelsio number of queue=12

Configuration sets:
  - no-affinity: default value, no cxl's queues interrupt binding
  - affinity-numa0: All 12 cxl's queue interrupt bind to core0-11
  - affinity-numa1: All 12 cxl's queues interrupt bind to core12-23

```
x no-affinity: inet4 packets-per-second
+ affinity-numa0: inet4 packets-per-second
* affinity-numa1: inet4 packets-per-second
+--------------------------------------------------------------------------+
|++       +    xx     + *     x          * **  *x                         *|
|            |__________M_A_____________|                                  |
||________M_A__________|                                                   |
|                                   |_______M_____A_____________|          |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      11016786      11118565      11043139      11052123     41519.938
+   5      10973710      11045921      11001495      11007283     33209.844
No difference proven at 95.0% confidence
*   5      11096776      11198400      11106924      11124071     42140.266
Difference at 95.0% confidence
	71947.8 +/- 61008.5
	0.650986% +/- 0.55378%
	(Student's t, pooled s = 41831.3)
```
