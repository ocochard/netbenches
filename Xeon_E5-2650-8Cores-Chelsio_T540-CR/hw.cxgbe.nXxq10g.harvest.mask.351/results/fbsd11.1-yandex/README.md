Impact of yandex's patchs and random.harvest.mask on forwarding performance
  - HP ProLiant DL360p Gen8 with eight cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11.1 patched
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - ntxq10g and nrxq10g = 1, 2, 3, 4, 5, 6, 7 and 8 (=number of core=default on this setup)
  - Traffic load at 14 Mpps
  - random.harvest.mask=351

![Impact of random.harvest.mask=351 and Chelsio rx/tx queue number on forwarding performance on FreeBSD](graph.png)
