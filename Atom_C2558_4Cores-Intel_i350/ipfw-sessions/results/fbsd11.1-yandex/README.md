Impact of number of UDP flows on ipfw performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11.1 with AFDATA and RADIX lock patches
  - multiple flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)

![Impact of number of UDP flows on ipfw performance with FreeBSD 11.1-yandex](graph.png)

