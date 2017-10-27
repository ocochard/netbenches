Impact of adding D12685 on ipfw performance: 5 Millions UDP sessions
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 12-head r325006 with Yandex patch (AFDATA and RADIX)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps
  - sysctl net.inet.ip.fw.dyn_max=5000000
  - sysctl net.inet.ip.fw.dyn_buckets=5000000

Result: From 32Kpps to 5.6Mpps

```
x r325006 with AFDATA/RADIX patches: inet4 Packets-per-second
+ r325006 with AFDATA/RADIX and D12685 patches: inet4 Packets-per-second
+--------------------------------------------------------------------------+
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|x                                                                        +|
|A                                                                         |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5         28583         36232       32290.5       32308.3     3725.3587
+   5       5661388       5697271       5687629       5682374     15266.038
Difference at 95.0% confidence
	5.65007e+06 +/- 16205.5
	17488% +/- 2092%
	(Student's t, pooled s = 11111.5)
```

For information, during the bench:
```
sysctl net.inet.ip.fw.curr_max_length
net.inet.ip.fw.curr_max_length: 9
```
