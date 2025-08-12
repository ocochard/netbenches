Impact of enabling ipfw, pf or ipf on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11.1-PRERELEASE (BSDRP 1.80)
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - hw.igb.rx_process_limit=-1
  - harvest.mask=351

![Impact of enabling ipfw/pf/ipf on forwarding performance on BSDRP 1.80 (FreeBSD 11.1-PRERELEASE)](graph.png)
