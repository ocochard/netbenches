Impact of HyperThreading on forwarding performance.
No benefit on This Intel Xeon E5-2650 (8c,16t), inet4 packets-per-seconds forwarded:

```
x HT-enabled and 8 queues(default)
+ HT-enabled increased to 16 queues (using all thread)
* HT-disabled and 8 queues
+--------------------------------------------------------------------------+
|                                                                        **|
|x      xx    x          +       + + +  +                               ***|
|   |____A_____|                                                           |
|                           |_____AM____|                                  |
|                                                                       |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4500078       4735822       4648451     4648293.8     94545.404
+   5       4925106       5198632       5104512     5088362.1     102920.87
Difference at 95.0% confidence
        440068 +/- 144126
        9.46731% +/- 3.23827%
        (Student's t, pooled s = 98821.9)
*   5       5765684     5801231.5       5783115     5785004.7     13724.265
Difference at 95.0% confidence
        1.13671e+06 +/- 98524.2
        24.4544% +/- 2.62824%
        (Student's t, pooled s = 67554.4)
```
