# Impact of harvest_mask on forwarding performance

Lab:
  - [SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)](https://www.supermicro.com/en/products/system/1U/5018/SYS-5018A-FTN4.cfm)
  - Chelsio T520-SO
  - FreeBSD 16-CURRENT n313366 (BSDRP 2.3)
  - GENERIC kernel
  - IPv4 only, 43-byte UDP packets, about 5000 flows
  - 2 static routes
  - Traffic load at 14.88 Mpps (10-Gigabit line rate)
  - 5 iterations per data point, reboot between each

The only difference between the two configuration sets is `harvest_mask`:
absent in `off_default`, `harvest_mask="351"` in `on`.

Verified on the DUT after each config-set's own reboot:

| configuration | kern.random.harvest.mask | INTERRUPT harvesting |
|---------------|--------------------------|----------------------|
| off_default   | 20959                    | enabled              |
| on            | 16735                    | disabled             |

# Results

Unit: Packets-per-second forwarded

| configuration | median  | minimum | maximum |
|---------------|---------|---------|---------|
| off_default   | 5542760 | 4776725 | 5574437 |
| on (351)      | 5518250 | 5068160 | 5705715 |

### Ministat

```
x off_default.pps
+ on.pps
+--------------------------------------------------------------------------+
|x                     +                             *    + x x +        + |
|                    |______________|___________A_____A___M_M____________|||
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4776725       5574437       5542760     5382311.5      341845.1
+   5       5068160       5705715       5518250     5468151.4     242243.85
No difference proven at 95.0% confidence
```

## Observation

**No difference proven at 95% confidence.** The medians are 0.44% apart, in
favour of *not* setting the mask, and the two ranges overlap almost
completely.

This contradicts the comment carried in the BSDRP configuration sets, which
claims the setting is "VERY important for 8 cores or more and allways
improve performance". On this hardware and this kernel it is not measurable.

Both halves of that comment ("Disable INTERRUPT and ETHERNET ... entropy
sources") deserve separate treatment:

  - **ETHERNET is already disabled and cannot be changed from userland.**
    `random_harvest_queue_ether()` is called in `ether_input()`
    (`sys/net/if_ethersubr.c`), but `sys/sys/random.h` compiles it to
    `do {} while (0)` unless the kernel defines `RANDOM_ENABLE_ETHER`. That
    option lives only in `sys/conf/NOTES`, not in GENERIC, and
    `kern.conftxt` on this DUT confirms its absence. The bit is also listed
    in `user_immutable_mask` (`sys/dev/random/random_harvestq.c`), so a
    userland write cannot flip it either way.

  - **INTERRUPT is genuinely switched by this setting** —
    `sys/kern/kern_intr.c` calls `random_harvest_queue(..., RANDOM_INTERRUPT)`
    gated only by the runtime mask, and the measured mask does change
    (20959 -> 16735). It simply buys nothing measurable at this packet rate.

### Caveat on precision

Both sample sets are noisy: 14.4% and 11.6% spread against under 2% for the
Intel 82599 benches on the neighbouring machine. This measurement therefore
rules out a large effect but cannot resolve a small one. A claim of the size
the configuration comment implies would have been obvious here; it is not
present.

## Consequence

`harvest_mask` was removed from the `firewalls` configuration sets for this
machine on the strength of this result, together with `icmp_drop_redirect`
(which is redundant while forwarding: `sys/netinet/ip_icmp.c` skips redirect
processing when `V_drop_redirect || V_ipforwarding`, and this DUT runs with
`net.inet.ip.forwarding=1`).
