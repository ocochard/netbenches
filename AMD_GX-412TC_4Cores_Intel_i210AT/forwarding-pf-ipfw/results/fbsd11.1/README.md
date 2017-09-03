Impact of enabling ipfw/pf/ipf on forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11.1
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

![Impact of enabling ipfw/pf/ipf on forwarding performance on FreeBSD 11.1](graph.png)

