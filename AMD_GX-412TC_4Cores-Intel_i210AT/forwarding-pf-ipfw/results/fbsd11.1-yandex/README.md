Impact of enabling ipfw/pf/ipf on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX locks) patch
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

![Impact of enabling ipfw/pf/ipf on forwarding performance on FreeBSD 11.1-yandex](graph.png)

Flamegraph:
   - [forwarding inet4](bench.forwarding.inet4.1.pmc.svg)
   - [forwarding inet6](bench.forwarding.inet6.1.pmc.svg)
   - [ipf-stateful inet4](bench.ipf-stateful.inet4.1.pmc.svg)
   - [ipf-stateful inet6](bench.ipf-stateful.inet6.1.pmc.svg)
   - [ipf-state inet4](bench.ipf-stateless.inet4.1.pmc.svg)
   - [ipf-state inet6](bench.ipf-stateless.inet6.1.pmc.svg)
   - [ipfw-stateful inet4](bench.ipfw-stateful.inet4.1.pmc.svg)
   - [ipfw-stateful inet6](bench.ipfw-stateful.inet6.1.pmc.svg)
   - [ipfw-stateless inet4](bench.ipfw-stateless.inet4.1.pmc.svg)
   - [ipfw-stateless inet6](bench.ipfw-stateless.inet6.1.pmc.svg)
   - [pf-stateful inet4](bench.pf-stateful.inet4.1.pmc.svg)
   - [pf-stateful inet6](bench.pf-stateful.inet6.1.pmc.svg)
   - [pf-statefuless inet4](bench.pf-stateless.inet4.1.pmc.svg)
   - [pf-statefuless inet6](bench.pf-stateless.inet6.1.pmc.svg)
