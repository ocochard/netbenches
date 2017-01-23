Impact of ipfw and pf on fastforwarding performance with default queue number (=8)
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR and OPT SFP (SFP-10G-LR)
  - FreeBSD 11-stable r312663
  - 2000 flows of smallest UDP packets
  - 2 static routes
  - Traffic load at 14.88 Mpps

![Impact of ipfw and pf on fastforwarding performance with default Cheliso queue on FreeBSD 11-stable](graph.png)

