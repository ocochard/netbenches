Impact of binding queue to CPU on fastforwarding performance
  - Supermicro X10DRi-LN4+, Xeon E5-2630 2x8cores at 2.40GHz
  - Dual port Intel X540-AT2 configured with 8 queues
  - BIOS setting: HT and APM disabled
  - FreeBSD 11-head r287478
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - harvest mask=351
  - incomming flows on ix0, outgoing flows on ix1 
  - Traffic load at 10 Mpps

![Impact of binding queue to CPU on fastforwarding performance on FreeBSD 11-head r287478](graph.png)
