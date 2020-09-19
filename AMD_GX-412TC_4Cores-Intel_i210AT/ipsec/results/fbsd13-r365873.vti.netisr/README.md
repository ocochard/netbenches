Testing net.isr diferred with 4 threads, to force load-sharing on all queues
/boot/loader.conf.local:
```
net.isr.numthreads=4
net.isr.maxthreads=4
net.isr.bindthreads=1
net.isr.dispatch=deferred
```

Results:

```
x null cypher:Mb/s
+ null cypher, netisr deferred: Mb/s
+--------------------------------------------------------------------------+
| +                                                                        |
|++                                                                     x x|
|++                                                                     xxx|
|                                                                       |A||
||A                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5           889           905           896         896.8     7.5299402
+   5           401           410           405         405.4     3.6469165
Difference at 95.0% confidence
	-491.4 +/- 8.62826
	-54.7948% +/- 0.57367%
	(Student's t, pooled s = 5.91608)
```
