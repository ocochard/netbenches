Impact of number of UDP flows on statefull firewalls performance
  - HP ProLiant DL360p Gen8 with height cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR).
  - FreeBSD 12-head r328509 with Yandex (AFDATA, RADIX lock, IPFW lockless) patches
  - n flows of smallest UDP packets
  - 2 firewall rules, 2 static routes
  - harvest.mask=351
  - net.inet.ip.fw.dyn_max=5000000
  - net.inet.ip.fw.dyn_buckets=5000000

![Impact of number of UDP flows on statefull firewalls on forwarding performance on FreeBSD 12-head r328509-yandex](graph.png)
