Impact of enabling ipfw, pf or ipf on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11.1 with Yandex's patch (AFDATA and RADIX locks)
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - ICMP redirect disabled

![Impact of enabling ipfw/pf/ipf on forwarding performance on BSDRP 1.96](graph.png)
