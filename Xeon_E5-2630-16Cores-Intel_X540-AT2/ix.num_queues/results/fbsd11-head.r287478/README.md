Impact of random.harvest.mask and Intel NIC rx/tx queue number on fastforwarding performance
  - Supermicro X10DRi-LN4+, Xeon E5-2630 2x8cores at 2.40GHz
  - Dual port Intel X540-AT2
  - BIOS setting: HT and APM disabled
  - FreeBSD 11-routing.r287531
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - harvest mask=351
  - Traffic load at 10 Mpps

![Impact of Intel X540-AT2 queue number on forwarding performance on FreeBSD 11-routing.r287531](graph.png)
