# Impact of simple+cache patch on forwarding performance

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

# Results

### Ministat

```
x iflib.simple_tx=0 and iflib.prefetch=0: packets-per-second forwarded
+ iflib.simple_tx=0 and iflib.prefetch=1: packets-per-second forwarded
* iflib.simple_tx=1 and iflib.prefetch=0: packets-per-second forwarded
% iflib.simple_tx=1 and iflib.prefetch=1: packets-per-second forwarded
+--------------------------------------------------------------------------+
|                                      %                                   |
|%*  %      *  **x                  +  % *          + +  +x    + xx       %|
|                 |_________________________A_____________M___________|    |
|                                         |_________A_M_______|            |
|  |___________M_A_____________|                                           |
| |_____________________________A______M_____________________|             |
+--------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   5       4563996     4692959.5       4671268     4637167.9     65541.784
+   5     4617466.5       4684615       4661076     4657819.7     24991.263
No difference proven at 95.0% confidence
*   5       4531761       4628340       4563828     4569664.4      35609.45
No difference proven at 95.0% confidence
%   5       4528525       4712606       4624697       4605739     75307.632
No difference proven at 95.0% confidence
```

## flamegraphs

  - [simple_tx=0, prefetch=0](bench.simple_tx_off_prefetch_off.pmc.svg)
  - [simple_tx=0, prefetch=1](bench.simple_tx_off_prefetch_on.pmc.svg)
  - [simple_tx=1, prefetch=0](bench.simple_tx_on_prefetch_off.pmc.svg)
  - [simple_tx=1, prefetch=1](bench.simple_tx_on_prefetch_on.pmc.svg)
