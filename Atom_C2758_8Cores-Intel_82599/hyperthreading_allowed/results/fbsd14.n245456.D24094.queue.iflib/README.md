Impact of D24094 "Fix allocation of queues to CPUs in iflib" on FreeBSD 14 current n257351 on forwarding performance:
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Dual port Intel Intel 82599
  - 5000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps
  - ICMP redirect disabled

```
x FreeBSD current n257351, hyperthreading_allowed=off: inet4 packets-per-second forwarded
+ FreeBSD current n257351: inet4 packets-per-second forwarded
* FreeBSD current n257351 with D24094, hyperthreading_allowed=off: inet4 packets-per-second forwarded
% FreeBSD current n257351 with D24094: inet4 packets-per-second forwarded
+--------------------------------------------------------------------------+
|+ x+xx+ ++                                       *         * O % %%*%    *|
|   |AM|                                                                   |
|  |__AM__|                                                                |
|                                                     |_______MA________|  |
|                                                              |__A_|      |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3641766       3666851       3666078     3660317.4     10693.732
+   5       3630515       3691715       3670135     3665515.6     24489.351
No difference proven at 95.0% confidence
*   5       3962488       4120734       4042086       4046775     59963.445
Difference at 95.0% confidence
	386458 +/- 62814.4
	10.558% +/- 1.72196%
	(Student's t, pooled s = 43069.5)
%   5       4041535       4085033       4066412     4063931.8     16453.486
Difference at 95.0% confidence
	403614 +/- 20237
	11.0268% +/- 0.571659%
	(Student's t, pooled s = 13875.8)
```
