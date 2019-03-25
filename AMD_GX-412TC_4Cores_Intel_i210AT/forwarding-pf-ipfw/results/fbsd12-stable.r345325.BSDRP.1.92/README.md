Impact of enabling ipfw, pf or ipf on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 12-stable r345325 (BSDRP 1.92)
  - 5000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

![Impact of enabling ipfw/pf/ipf on forwarding performance on BSDRP 1.92 (FreeBSD 12-STABLE r345325)](graph.png)
