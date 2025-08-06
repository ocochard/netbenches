Benefit of IPFW-at-NIC-level receiving 13Mpps of DDoS and 1Mpps of legitimate trafic

With number of NIC queue reduced to 1:

```
x ipfw.1rx.pps
+ ipfw-at-nic-level.1rx.pps
+--------------------------------------------------------------------------+
|xx                                                               +   + +++|
|A|                                                                        |
|                                                                   |__AM_||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      126883.5        127474        127300      127221.2     228.54447
+   5        186416      193007.5      191362.5      190591.4     2705.1625
Difference at 95.0% confidence
	63370.2 +/- 2799.7
	49.811% +/- 2.21034%
	(Student's t, pooled s = 1919.65)
```

With standard number of queue to 8:

```
x ipfw.8rx.pps
+ ipfw-at-nic-level.8rx.pps
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|                                                                         +|
|   x                                                                     +|
|x  xxx                                                                   +|
| |_A_|                                                                    |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      455702.5        494585        481205      479885.4     14651.614
+   5        999022        999652      999599.5      999492.5     264.33312
Difference at 95.0% confidence
	519607 +/- 15112.3
	108.277% +/- 6.55814%
	(Student's t, pooled s = 10361.9)
```

With number of queue increased to 16 (using threads), this bench doesn't
allow to correctly measure the impact of this feature:

```
x ipfw.16rx.pps
+ ipfw-at-nic-level.16rx.pps
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|                                                                         +|
|                                                                         +|
|x                                            x       x   xx              +|
|                  |________________________A_________M_____________|      |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      895624.5        979070        972102      956771.6     35008.966
+   5      999940.5     1000000.5        999946      999965.2     30.717666
Difference at 95.0% confidence
	43193.6 +/- 36103.9
	4.51452% +/- 3.94387%
	(Student's t, pooled s = 24755.1)
```
