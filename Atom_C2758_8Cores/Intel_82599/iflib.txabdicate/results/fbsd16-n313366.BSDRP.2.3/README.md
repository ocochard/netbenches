# Impact of iflib tx_abdicate on forwarding performance

Lab:
  - [SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)](https://www.supermicro.com/en/products/system/1U/5018/SYS-5018A-FTN4.cfm)
  - Dual port Intel X520 82599ES
  - FreeBSD 16-CURRENT n313366 (BSDRP 2.3)
  - GENERIC kernel
  - IPv4 only, 43-byte UDP packets (smallest, Ethernet padding)
  - about 5000 flows (71 source x 70 destination addresses)
  - 2 static routes
  - Traffic load at 14.88 Mpps (10-Gigabit line rate)
  - iflib.override_ntxds=1024 (was 2048 by default)
  - iflib.override_nrxds=1024 (was 2048 by default)
  - iflib.tx_reclaim_thresh=256
  - 5 iterations per data point, reboot between each

The only difference between the two configuration sets is
`dev.ix.{0,1}.iflib.tx_abdicate`: absent (driver default 0) in
`off_default`, set to 1 in `on`.

# Results

Unit: Packets-per-second forwarded

| configuration    | median  | minimum | maximum |
|------------------|---------|---------|---------|
| off_default (0)  | 3947118 | 3936078 | 4000666 |
| on (1)           | 4808557 | 4745125 | 4852494 |

### Ministat

```
x off_default.pps
+ on.pps
+--------------------------------------------------------------------------+
| x                                                                       +|
|xx  xx                                                          +  + +   +|
||MA__|                                                            |__A___||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3936078       4000666       3947118     3961877.4     28829.079
+   5     4745125.5       4852494       4808557     4806359.4     46404.356
Difference at 95.0% confidence
	844482 +/- 56338.9
	21.3152% +/- 1.51255%
	(Student's t, pooled s = 38629.5)
```

## Observation

Enabling `tx_abdicate` is worth **+21.3% +/- 1.5%** on this hardware. The two
sample sets do not overlap at all — the slowest `on` iteration (4745125) is
still 18.6% above the fastest `off_default` iteration (4000666) — so the
effect is far larger than the run-to-run noise (spread 1.6% and 2.2%
respectively).

With `tx_abdicate=0` the transmitting thread pushes the packet to the wire
itself; with 1 it hands the doorbell write to the iflib tx task instead. On
this 8-core Atom, deferring that work is a clear win at line rate.

This measurement is the justification for that choice rather than an
assumption. [`icmp_drop_redirect`](../../../icmp_drop_redirect/) on this
machine sets `tx_abdicate=1` in both of its configuration sets and uses the
same 43-byte / ~5000-flow profile, so its ~4.7 Mpps figures are directly
comparable to the `on` result here.

Note that [`iflib.simple_tx`](../../../iflib.simple_tx/) is a separate axis,
not a comparable one: its own configuration carries the upstream note that
"when this is enabled, the tx_abdicate sysctl is no longer applicable and is
ignored". So `simple_tx=1` and the +21.3% measured here are alternative ways
of addressing the same transmit path, and the two cannot be added together.
