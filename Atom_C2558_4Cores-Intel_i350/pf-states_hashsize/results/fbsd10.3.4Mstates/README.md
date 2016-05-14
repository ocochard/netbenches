Impact of pf.states_hashsize with pf max states to 4M with FreeBSD 10.3
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11-head r287478
  - 2M unidirectionnal UDP flows (generate 4M states) of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of pf.states_hashsize with 4M states on FreeBSD 10.3](graph.png)

