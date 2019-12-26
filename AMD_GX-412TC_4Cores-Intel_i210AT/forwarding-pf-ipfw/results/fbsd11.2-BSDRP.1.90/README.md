Comparing BSDRP 1.80 vs 1.90 forwarding performance
  - PC Engines APU2C4 (quad core AMD GX-412T Processor 1 GHz)
  - 3 Intel i210AT Gigabit Ethernet ports
  - FreeBSD 11.1-PRERELEASE (BSDRP 1.80) vs FreeBSD 11.2-BETA3+Yandex+pf-MFC (BSDRP 1.90)
  - 5000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

![Comparing BSDRP 1.80 vs 1.90 forwarding performance](graph.png)
