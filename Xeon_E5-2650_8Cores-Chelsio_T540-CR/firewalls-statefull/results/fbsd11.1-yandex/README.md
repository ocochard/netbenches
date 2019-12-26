Impact of number of UDP flows on statefull firewalls performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 11.1 with Yandex (AFDATA and RADIX lock) patches
  - n flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - harvest.mask=351

![Impact of number of UDP flows on statefull firewalls on forwarding performance on FreeBSD 11.1-yandex](graph.png)
