Cypher impact on IPsec gateway performance:
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 13-head r365873
  - VTI (if_ipsec) mode
  - dev.igb.*.iflib.tx_abdicate=1
  - 2000 flows of UDP packets
  - 500Bytes UDP load => packet size: 528B => Ethernet frame size:542B

![Impact of cyphers on IPsec VIT mode performance on Netgate RCC-VE 4860](graph.png)
