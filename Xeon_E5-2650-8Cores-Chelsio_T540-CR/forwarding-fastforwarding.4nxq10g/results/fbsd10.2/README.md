Comparing impact of enabling fastforwarding
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 10.2
  - 2000 flows of smallest UDP packets
  - ntxq10g and nrxq10g = 4 (and not the default value of ncpu=8)
  - Traffic load at 10Mpps

Same performance (at 95% confidence) with D5330 and fastforwarding mode:

```
x pps.forwarding
+ pps.fastforwarding
+--------------------------------------------------------------------------+
|   x                                                                    + |
|xx x x  xxx xx                                         + + ++ +     +  +++|
|  |___AM___|                                                              |
|                                                          |______A______| |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10        863031       1163347     1016572.8     1014444.7     103384.17
+  10       2147676       2563598     2378921.8     2375603.1     160971.63
Difference at 95.0% confidence
        1.36116e+06 +/- 127106
        134.178% +/- 12.5297%
        (Student's t, pooled s = 135278)

```
