Impact of flows/pf state on performance with FreeBSD 10.3
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-head r287478
  - multiple flows of smallest UDP packets until pf max default (10K)
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of flows/pf state with pf max default on performance with FreeBSD 10.3](graph.png)

