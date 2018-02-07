
![Impact of enabling ipfw/pf/ipf on forwarding performance on FreeBSD 11.1-yandex](graph.png)

Diff between tunned inet4 vs inet6:

```
x forwarding.inet4.pps
+ forwarding.inet6.pps
+--------------------------------------------------------------------------+
|+                                                                         |
|++                                                                      xx|
|++                                                                     xxx|
|                                                                        A||
|A|                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      14787820      14796123      14793058      14792657     3255.5324
+   5      14467922      14470456      14470089      14469670     1020.7004
Difference at 95.0% confidence
        -322987 +/- 3518.49
        -2.18343% +/- 0.023313%
        (Student's t, pooled s = 2412.5)
```

Diff between generic untuned 11.1 vs tunned&yandex patched 11.1

```
x ../../../kern.random.harvest.mask/results/fbsd11.1/511-default.pps
+ forwarding.inet4.pps
+--------------------------------------------------------------------------+
|                                                                         +|
|                                                                         +|
|x                                                                        +|
|xx                                                                       +|
|xx                                                                       +|
|MA                                                                        |
|                                                                         A|
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4784586       4955119     4829581.5     4862892.3     74480.616
+   5      14787820      14796123      14793058      14792657     3255.5324
Difference at 95.0% confidence
        9.92977e+06 +/- 76883.3
        204.195% +/- 4.80529%
        (Student's t, pooled s = 52716)
```
