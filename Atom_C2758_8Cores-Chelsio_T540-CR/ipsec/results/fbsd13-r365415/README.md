Impact of cyphers on IPsec performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - FreeBSD 13-head r365415
  - 4 SAD/SPD (2 IPv4, 2 IPv6)
  - 5000 flows of clear UDP packets
  - 500Bytes UDP load => packet size: 528B => Ethernet frame size:542B

![Impact of cyphers on IPsec performance on SuperServer 5018A-FTN4](graph.png)
