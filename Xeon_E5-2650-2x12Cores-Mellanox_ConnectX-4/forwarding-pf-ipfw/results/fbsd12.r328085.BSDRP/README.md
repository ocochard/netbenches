Impact of enabling firewalls on FreeBSD's forwarding performance
  - Dell PowerEdge R630 with 2 Intel E5-2650 v4 2.2Ghz (2x12 cores)
  - Mellanox ConnectX-4 LC (10Giga DAC cable)
  - Minimum firewall rules
  - HyperThreading and LRO/TSO disabled
  - harvest.mask=351
  - Yandex patches applied: AFDATA lock, RADIX lock, IPFW-statefull-lockless(D12685)"

![Impact of enabling ipfw/pf/ipf on forwarding performance on FreeBSD 12-head r328085 with Yandex patches](graph.png)
