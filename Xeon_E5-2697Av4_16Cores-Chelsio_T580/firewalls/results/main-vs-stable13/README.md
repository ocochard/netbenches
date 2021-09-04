Comparing MAIN vs STABLE-13 on firewalling performance:
  - Intel Xeon E5-2697Av4 (16Cores, 32 threads)
  - RX NIC (heavy work): Chelsio T580-LP-CR (QSFP+ 40GBASE-SR4)
  - TX NIC: Mellanox_ConnectX-4
  - Increase number of Chelsio RX & TX queues to 32
  - FreeBSD STABLE n265892 and MAIN n268154
  - Traffic load at 42.49Mpps
  - 2 static routes
  - LRO/TSO disabled
  - harvest.mask=351
  - ICMP redirect disabled

[Impact of firewalling: MAIN vs STABLE-13](graph.png)
