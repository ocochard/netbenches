Impact of firewalls on forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Dual port Intel Intel 82599
  - FreeBSD 14-head c276570 (BSDRP 1.991)
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps
  - harvest.mask=351
  - net.inet.ip.redirect=0
  - net.inet6.ip6.redirect=0
  - txabdicate enabled

![Impact of firewalls on forwarding performance with BSDRP 1.991](graph.png)
