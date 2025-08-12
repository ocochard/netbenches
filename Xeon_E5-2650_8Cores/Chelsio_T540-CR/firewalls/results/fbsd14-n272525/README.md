Impact of enabling ipfw/pf/ipf on forwarding performance
  - HP ProLiant DL360p Gen8 with 8 cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 14 head (n272525)
  - 5000 flows of smallest UDP packets at 14.88 Mpps
  - 2 firewall rules, 2 static routes
  - harvest.mask=351
  - ICMP redirect disabled

![Impact of enabling ipfw/pf/ipf on forwarding performance on tunned FreeBSD 14 head n272525](graph.png)
