Impact of queues number on forwarding performance
  - Dell PowerEdge R630 with 2 Intel E5-2650 v4 2.2Ghz (2x12 cores)
  - Dual port Intel 82599ES
  - FreeBSD 11.1 with AFDATA and RADIX patches
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.48 Mpps
  - random.harvest.mask=351

![Intel 82599ES rx/tx queue number impact on FreeBSD forwarding performance](graph.png)
