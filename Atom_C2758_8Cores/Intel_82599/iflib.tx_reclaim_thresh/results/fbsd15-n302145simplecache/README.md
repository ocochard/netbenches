# Impact of iflib.tx_reclaim_thresh on forwarding performance

Lab:
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Dual port Intel Intel 82599
  - FreeBSD 15-head n302145 (e69573bc2be) with simple+cache patches
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 12 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - iflib.tx_abdicate=1
  - iflib.override_ntxds=1024 (was 2048 by default)
  - iflib.override_nrxds=1024 (was 2048 by default)

dev.ix.X.iflib.tx_reclaim_thresh: Number of TX descs outstanding before reclaim is called

# Results

### Ministat

Unit: packets-per-second forwarded
```
x iflib.simple_tx=0 and iflib.tx_reclaim_thresh=0 (default)
+ iflib.simple_tx=1 and iflib.tx_reclaim_thresh=0 (default)
* iflib.simple_tx=0 and iflib.tx_reclaim_thresh=256 (25%)
% iflib.simple_tx=1 and iflib.tx_reclaim_thresh=256 (25%)
# iflib.simple_tx=0 and iflib.tx_reclaim_thresh=512 (50%)
@ iflib.simple_tx=1 and iflib.tx_reclaim_thresh=512 (50%)
+--------------------------------------------------------------------------+
|                      @                                                   |
|++    @   #x+@  xx##x OO@                        %      % %%  * * *      *|
|             |__AM__|                                                     |
||_________A_M______|                                                      |
|                                                              |___MA_____||
|                                                    |___A_M_|             |
|             |____AM___|                                                  |
|          |______A____M__|                                                |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5     4617466.5       4684615       4661076     4657819.7     24991.263
+   5       4528525       4712606       4624697       4605739     75307.632
No difference proven at 95.0% confidence
*   5     5019428.5       5106089       5049506     5062289.3     40795.968
Difference at 95.0% confidence
	404470 +/- 49338.4
	8.68367% +/- 1.08513%
	(Student's t, pooled s = 33829.5)
%   5     4919794.5       4998494       4989614     4973903.5     31875.793
Difference at 95.0% confidence
	316084 +/- 41771.4
	6.78609% +/- 0.920445%
	(Student's t, pooled s = 28641.1)
#   5       4610862       4708805       4675886       4673713     38421.858
No difference proven at 95.0% confidence
@   5       4573818       4717201       4701017       4665635     61491.418
No difference proven at 95.0% confidence
```

## flamegraphs

  - [simple_tx=0, tx_reclaim_thresh=0 (default)](../../../iflib.simple_tx/results/fbsd15-n302145simplecache/bench.simple_tx_off_prefetch_on.pmc.svg)
  - [simple_tx=1, tx_reclaim_thresh=0 (default)](../../../iflib.simple_tx/results/fbsd15-n302145simplecache/bench.simple_tx_on_prefetch_on.pmc.svg)
  - [simple_tx=0, tx_reclaim_thresh=256](bench.simple_tx_off_tx_reclaim_thresh_25p.pmc.svg)
  - [simple_tx=1, tx_reclaim_thresh=256](bench.simple_tx_on_tx_reclaim_thresh_25p.pmc.svg)
  - [simple_tx=0, tx_reclaim_thresh=512](bench.simple_tx_off_tx_reclaim_thresh_50p.pmc.svg)
  - [simple_tx=1, tx_reclaim_thresh=512](bench.simple_tx_on_tx_reclaim_thresh_50p.pmc.svg)
