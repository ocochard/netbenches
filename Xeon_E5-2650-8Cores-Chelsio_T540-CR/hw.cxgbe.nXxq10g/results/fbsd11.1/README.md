Impact of Chelsio rx/tx queue number on forwarding performance
  - HP ProLiant DL360p Gen8 with eight cores (Intel Xeon E5-2650 @ 2.60GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11.1
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.48 Mpps
  - machdep.hyperthreading_allowed=0

![Impact of Chelsio queues number on forwarding performance on FreeBSD 11.1](graph.png)
