Impact of enabling pf/ipfw/ipf on forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 12-head r319810
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps

![Impact of enabling pf/ipfw/ipf on forwarding performance on fbsd12-head r319810](graph.png)

flame graph:
   - [forwarding inet4](bench.forwarding.inet4.1.pmc.svg)
   - [forwarding inet6](bench.forwarding.inet6.1.pmc.svg)
   - [ipf-statefull inet4](bench.ipf-statefull.inet4.1.pmc.svg)
   - [ipf-statefull inet6](bench.ipf-statefull.inet6.1.pmc.svg)
   - [ipf-stateless inet4](bench.ipf-stateless.inet4.1.pmc.svg)
   - [ipf-stateless inet6](bench.ipf-stateless.inet6.1.pmc.svg)
   - [ipfw-statefull inet4](bench.ipfw-statefull.inet4.1.pmc.svg)
   - [ipfw-statefull inet6](bench.ipfw-statefull.inet6.1.pmc.svg)
   - [ipfw-stateless inet4](bench.ipfw-stateless.inet4.1.pmc.svg)
   - [ipfw-stateless inet6](bench.ipfw-stateless.inet6.1.pmc.svg)
   - [pf-statefull inet4](bench.pf-statefull.inet4.1.pmc.svg)
   - [pf-statefull inet6](bench.pf-statefull.inet6.1.pmc.svg)
   - [pf-stateless inet4](bench.pf-stateless.inet4.1.pmc.svg)
   - [pf-stateless inet6](bench.pf-stateless.inet6.1.pmc.svg)

They were generated with this command:
```
stackcollapse-pmc.pl bench.312905.1.pmc.graph | flamegraph.pl > bench.312905.svg

```
