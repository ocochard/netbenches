Impact of cyphers on IPsec VTI (route-based) performance (IPv4 and IPv6)
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz), DUT = sm1
  - Quad port Chelsio 10-Gigabit T540-CR
  - FreeBSD 16-CURRENT n313366 (BSDRP 2.3)
  - AES-NI in the kernel (`aesni0: <AES-CBC,AES-CCM,AES-GCM,AES-ICM,AES-XTS>`),
    `kern.crypto.allow_soft=0`
  - **VTI (route-based)**: `if_ipsec(4)` interface, reqid 100 on the DUT and
    200 on the peer, SAs bound to it with `-u`, no SPD entry
  - 4 SAs per cypher (2 IPv4, 2 IPv6), tunnel mode
  - **2000 flows of clear UDP packets in BOTH address families**
  - LRO disabled on both DUT interfaces
  - 500Bytes UDP load => 542B Ethernet frame in IPv4, 562B in IPv6

![Impact of cyphers on IPsec VTI throughput on SuperServer 5018A-FTN4](graph.png)

```
cypher                       IPv4   IPv6
null                         2036   1655
aes-gcm-128                  1526   1678
aes-gcm-256                  1482   1682
aes-cbc-128-hmac-sha1         908   1126
aes-cbc-256-hmac-sha2-256     934    982
```

Values are Mb/s, median of 5 benches.

## Why this set exists

It replaces an earlier set that was withdrawn as a cross-family comparison:
its IPv4 arm generated ~4970 flows against the IPv6 arm's 2000, so no
IPv4-to-IPv6 ratio in it was flow-matched. Here both families run 2000 flows.
That set's own withdrawal note is kept as [`WITHDRAWN-5kflows-v4.md`](WITHDRAWN-5kflows-v4.md);
its measurements are superseded by the ones here and were not retained.

**The flow count turned out not to matter on this DUT.** Re-measuring IPv4 at
2000 flows instead of ~4970 moved the unimodal cyphers by about 1%:

```
cypher                     5k flows   2k flows   delta
null                           2062       2036   -1.3%
aes-cbc-128-hmac-sha1           920        908   -1.3%
```

So the withdrawn set's per-family IPv4 figures were not wrong, and the defect
was confined to the ratios. The IPv6 arm is unchanged between the two sets (it
already ran 2000 flows) and measures the same: null 1661 then 1655, cbc-128
1119 then 1126.

## The IPv6 result is not a simple penalty

Converting to packets per second removes the frame-size difference (542B in
IPv4 against 562B in IPv6):

```
cypher                      v4 kpps  v6 kpps  v6/v4
null                          452.8    355.5   0.78
aes-gcm-128                   339.4    360.4   1.06
aes-gcm-256                   329.6    361.3   1.10
aes-cbc-128-hmac-sha1         202.0    241.8   1.20
aes-cbc-256-hmac-sha2-256     207.7    210.9   1.02
```

IPv6 is 22% slower per packet with no crypto, and level or *faster* with it.
A fixed per-packet IPv6 overhead cannot produce that: such a cost would shrink
towards parity as crypto came to dominate, never cross it.

This reproduces the same pattern the withdrawn set showed, now at matched flow
counts, so it was never a flow-count artifact. It remains **unexplained**. The
hwpmc callgraphs carried over from that set (`PMC/`) show the IPv4 and IPv6
null profiles differing by under half a point in every bucket, so whatever
causes it is not visible as a shift in where cycles go.

The aes-cbc-256 ratio of 1.02 here against 1.10 in the withdrawn set should
not be read as a change: that cypher's reported values are the least reliable
in the set, for the reason below.

## The reported equilibrium understates the weak cyphers

equilibrium reports whatever its *last* probe measured once the step falls
below tolerance. There is no confirmation pass. When a probe near the knee
dips, that dip becomes the answer even though the search already sustained a
higher rate. The `maximum value seen` field, aggregated here into
`gnuplot.data.max`, does not have that failure mode.

For the AES-CBC cyphers the difference is large and the max series is
dramatically more repeatable:

```
                              reported (median/min/max)   max seen (median/min/max)
inet6.aes-cbc-256-hmac-sha2-256    982 /  869 / 1017        1049 / 1048 / 1050
inet4.aes-cbc-256-hmac-sha2-256    934 /  884 /  952         958 /  940 /  999
inet6.aes-cbc-128-hmac-sha1       1126 / 1058 / 1136        1158 / 1136 / 1176
```

Five IPv6 aes-cbc-256 runs peaked at 1048, 1049, 1049, 1050 and 1048 Mb/s: a
3 Mb/s spread. Their reported equilibria spread 148 Mb/s. The DUT did the same
work every time and the search stopped in a different place.

**So for the AES-CBC cyphers, read `gnuplot.data.max`.** For AES-GCM do not:
its max series is contaminated the other way. `inet4.aes-gcm-128` shows a
1999 Mb/s maximum, taken at a 2000 Mb/s offer, and that sample is not a
sustained rate: the NIC counters for that iteration read `rx_frames`
107034036 against `tx_frames` 105729622, so the DUT dropped 1.3M of 107M
frames (1.2%) while producing it. It was already saturated and losing; the
median simply landed before the queues filled. An offer ceiling, not a knee.
The plotted `graph.png` uses the reported series throughout for consistency
with earlier sets.

## IPv4 AES-GCM spreads 8% and must not be differenced across sets

In IPv4 the AES-GCM cyphers spread about 8% between iterations. The spread
tracks whatever the DUT delivered at the 2000 Mb/s probe:

```
iter   equilibrium   rate at the 2000 Mb/s offer   walk after that probe
  1           1646                          1648   descends from 1750
  2           1650                          1999   climbs to 2500
  3           1519                          1532   descends from 1750
  4           1526                          1516   descends
  5           1476                          1519   descends
```

**This is not two stable states of the DUT.** Read in iteration order the
values are two high then three low, monotonic, with no return to the high
group: one transition, not two modes sampled at random. Five iterations cannot
distinguish two modes from a single step, and the ordering argues against
modes. An earlier revision of this file called it bimodal and proposed
per-boot RSS or crypto-thread placement as the cause; the counters below rule
that out.

**The cause is that the knee sits between two rungs of the offer ladder.**
`equilibrium` climbs by a constant `LINK_RATE/4` while the trend is
increasing, so `-l 2000` fixes the offers at 1000, 1500, 2000, 2500. True
aes-gcm-128 capacity is about 1650 Mb/s, which falls between the 1500 and 2000
rungs, so that third offer straddles the knee. Whatever that single probe
returns then decides the entire deterministic bisection that follows, and the
final figure is that one sample propagated. That is why the results look like
states.

The other cyphers are the control, and they place the effect on the ladder
rather than on AES-GCM:

```
cypher                  capacity   position on the ladder        spread
inet4.null                 ~2036   above 2000, always reads 1999   1.5%
inet4.aes-cbc-128-sha1      ~908   clear of the 1000 rung          2.2%
inet6.aes-gcm-128          ~1678   straddles, but path-pinned        2%
```

IPv4 AES-GCM is the only cypher here whose knee sits just under a rung with
nothing else binding to hold it steady. IPv6 AES-GCM straddles the same rung
but the forwarding path saturates at about 1670 Mb/s and pins the knee to the
same place on every boot, which is why it shows no split (1650-1718 across
five runs). See the section below.

**Consequence for analysis, unchanged.** The median over 5 iterations reports
which side of the rung the majority of probes fell on, not a property of the
DUT: the 5k set landed 3-of-5 high (median 1650), this set 3-of-5 low (1526).
**That 8% is not a flow-count effect and IPv4 AES-GCM medians must not be
differenced between result sets.**

Ruled out as causes: the crypto backend is identical on every boot
(`dev.aesni.0` + `dev.cryptosoft.0`, no QAT) in all five `.before` captures,
and field 2 of `kern.crypto.stats` is zero on every iteration, so there is no
dispatch backpressure.

No flag suppresses this. `TOLERANCE` (default 0.01) is the acceptance band
around the offer, not a repeat count: the search takes one sample per offer,
latches `PEAK` on the first trend reversal and only halves `STEP` after that,
so a single unlucky probe is structurally decisive. Averaging repeated probes
per rung would require patching `equilibrium` itself.

## In IPv6 the forwarding path, not the cypher, is the limit

null, aes-gcm-128 and aes-gcm-256 measure 1655, 1678 and 1682 Mb/s: a 27 Mb/s
spread across three very different cyphers, which is inside the run-to-run
noise of any one of them. AES-GCM is effectively free here; the IPv6
forwarding path saturates first.

That ceiling is real and not an artifact of the generator. At the 1000 and
1500 Mb/s offers the generator delivered 999 and 1499 Mb/s with no shortfall
in every null iteration, and the knee appears only above ~1650. It is also not
a ceiling that hides all cypher differences, because AES-CBC sits well below
it (1126 and 982 Mb/s) and orders correctly by cost.

## Method note on -l

`SENDER_START_CMD` declares `-l 2000`. That is not a ceiling on the result:
equilibrium's step halves only after the trend first reverses, so while the
trend is increasing the offer climbs by a constant `LINK_RATE/4`. `-l 2000`
walks 1000, 1500, 2000, 2500 and the IPv4 null cypher correctly reports 2036
Mb/s under it.

Raising `-l` so the first offer always starts above the knee, which would
narrow the AES-GCM spread by making the search always descend, was
considered and rejected for this sweep. Clearing null's 2073 Mb/s needs
`-l >= 4150`, which forces the initial step to >= 1037 Mb/s, above the entire
capacity of aes-cbc-256. One observed IPv4 aes-cbc-256 trace already measured
only 558 Mb/s at a 1000 Mb/s offer (1.13x its capacity); under a 2200 Mb/s
first offer a result that low would fall below the step and trigger
equilibrium's "forwarding rate too low" clamp, seeding the whole search from a
collapsed value. A per-cypher `-l` would work, but it changes the methodology
and breaks comparability with every set measured at 2000.

*Lowering* `-l` is the better lever for the AES-GCM spread specifically, and
was not considered at the time. `-l 1600` puts the rungs at 800, 1200, 1600
and 2000, so the ~1650 knee is approached from 1600 below instead of 2000
above and the straddle narrows from 500 to 400 Mb/s. It would clip null, whose
capacity is above 2000, so it cannot be applied to the whole sweep either. The
same comparability objection applies: any future run that changes `-l` cannot
be differenced against this set.

## Raw data

`RAW/inet4/` and `RAW/inet6/` hold the per-iteration sender, receiver-side
`.before` and `.after` captures, and `.info` files. The two families use
identical filenames and must stay in separate directories.
