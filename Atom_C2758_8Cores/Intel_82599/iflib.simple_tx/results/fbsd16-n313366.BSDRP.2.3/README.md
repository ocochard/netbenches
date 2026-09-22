# Impact of iflib simple_tx on forwarding performance

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
`dev.ix.{0,1}.iflib.simple_tx`: absent (default 0) in `off_default`, set to 1
in `on`.

# Results

Unit: Packets-per-second forwarded

| configuration    | median  | minimum | maximum |
|------------------|---------|---------|---------|
| off_default (0)  | 3961799 | 3948066 | 3980074 |
| on (1)           | 4490599 | 4474545 | 4496274 |

### Ministat

```
x off_default.pps
+ on.pps
+--------------------------------------------------------------------------+
|                                                                        + |
|    x                                                                   + |
|xxx x                                                                 + ++|
||_A_|                                                                  |A||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       3948066       3980074       3961799     3965237.3     14127.039
+   5       4474545       4496274     4490599.5     4488367.7     8229.5726
Difference at 95.0% confidence
	523130 +/- 16860.6
	13.1929% +/- 0.467731%
	(Student's t, pooled s = 11560.7)
```

## Observation

Enabling `simple_tx` is worth **+13.2% +/- 0.5%** on this hardware. The two
sample sets do not overlap and the spreads are tight (0.8% and 0.5%), so the
result is unambiguous.

`simple_tx` replaces the iflib multi-packet transmit path with a simpler ring
that sends one packet at a time. On this 8-core Atom the reduced per-packet
work is a clear win at line rate.

## simple_tx versus tx_abdicate

These two tunables are **alternatives, not complements**: the iflib source
notes that when `simple_tx` is enabled "the tx_abdicate sysctl is no longer
applicable and is ignored". Measured on this machine, same revision, same
traffic profile, same day:

| configuration            | median  | gain over its own baseline |
|--------------------------|---------|----------------------------|
| baseline (both off)      | ~3.95 M | -                          |
| simple_tx=1              | 4490599 | +13.2%                     |
| [tx_abdicate=1](../../../iflib.txabdicate/results/fbsd16-n313366.BSDRP.2.3/README.md) | 4808557 | +21.8% |

**`tx_abdicate=1` is the better choice on this hardware**, beating
`simple_tx=1` by 7.1% (4808557 vs 4490599). Both are worth enabling over the
stock default, but only one of them can be in effect.

The two runs' `off_default` baselines agree to within 0.37% (3961799 here
against 3947118 in the tx_abdicate bench) despite being separate sweeps with
reboots between every iteration, which is a useful check that both sets of
numbers are sound.

## Note on the earlier result set for this machine

[`fbsd15-n302432`](../fbsd15-n302432/README.md) reports `off_default`
3564885 against `on` 3539270 — a 0.7% *decrease*, i.e. no effect — alongside
a third set, `tx_abdicate` at 4668850. Its `tx_abdicate` figure is consistent
with the 4808557 measured here, but its `simple_tx` result is not consistent
with the +13.2% above.

The likely explanation is that `simple_tx` was never actually enabled in that
run. The configuration set currently in this repository places the
`simple_tx` lines in `etc/sysctl.conf`, where they cannot take effect,
because the oid is a read-only loader tunable. Verified on this DUT:

```
# sysctl dev.ix.0.iflib.simple_tx=1
sysctl: oid 'dev.ix.0.iflib.simple_tx' is a read only tunable
sysctl: Tunable values are set in /boot/loader.conf
```

This is not proof about the n302432 run itself — that result set does not
preserve the configuration it used, so the `sysctl.conf` placement cannot be
confirmed retrospectively. It is the most plausible cause given that the
present config-set has that defect and would produce exactly the observed
null.

For this run the two lines were moved to `boot/loader.conf.local` (quoted, as
the i210 config-sets on the APU2 already do), and the value was confirmed to
read 1 on the `on` set and 0 on `off_default` before trusting the numbers.
