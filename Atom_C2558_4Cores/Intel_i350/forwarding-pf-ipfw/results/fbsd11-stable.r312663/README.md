ipfw/pf's impact on forwarding performance:
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-stable r312663
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of ipfw/pf on forwarding performance on FreeBSD 11-stable](graph.png)
