Impact of firewall table size on FreeBSD 11.1 forwarding performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX lock) patches
  - 2000 flows of smallest UDP packets
  - firewall rules, 2 static routes
  - harvest.mask=351

![Impact of firewall table size on FreeBSD 11.1-yandex forwarding performance](graph.png)
