```
x ../../../forwarding-pf-ipfw/results/fbsd11.1-yandex/forwarding.inet4.pps
+ vlan.inet4.pps
* vlan-no-hw.inet4.pps
+--------------------------------------------------------------------------+
|*                         +                                             x |
|*                         ++                                            xx|
|***                       ++                                            xx|
|                                                                        A||
|                          A|                                              |
|MA                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5      10917371      10970686      10945136      10946743     22298.313
+   5       9056449       9104195       9064032     9075563.7     21531.387
Difference at 95.0% confidence
	-1.87118e+06 +/- 31966.4
	-17.0935% +/- 0.267353%
	(Student's t, pooled s = 21918.2)
*   5       8007220       8074732       8017098     8029088.6     26769.461
Difference at 95.0% confidence
	-2.91765e+06 +/- 35929.5
	-26.6532% +/- 0.295534%
	(Student's t, pooled s = 24635.5)
```

```
x ../../../forwarding-pf-ipfw/results/fbsd11.1-yandex/forwarding.inet6.pps
+ vlan.inet6.pps
* vlan-no-hw.inet6.pps
+--------------------------------------------------------------------------+
| *                                +                                      x|
|**                                +                                      x|
|**                                +                                     xx|
|                                                                        |A|
|                                  A                                       |
||A                                                                        |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       9168501       9190298     9183054.5     9181214.1     8309.7017
+   5       7853020       7863010       7857647       7857269     4125.9995
Difference at 95.0% confidence
	-1.32395e+06 +/- 9567.82
	-14.4202% +/- 0.0923497%
	(Student's t, pooled s = 6560.3)
*   5       6680390       6717141       6697808     6698576.3     13754.502
Difference at 95.0% confidence
	-2.48264e+06 +/- 16572.3
	-27.0404% +/- 0.168839%
	(Student's t, pooled s = 11363)
```

Flamegraph:
   - [vlan tagging](bench.vlan.1.pmc.svg)
   - [vlan tagging with hardware acceleration disabled](bench.vlan-no-hw.1.pmc.svg)
