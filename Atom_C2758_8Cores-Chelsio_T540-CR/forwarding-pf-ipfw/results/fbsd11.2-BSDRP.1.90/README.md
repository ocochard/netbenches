Impact of enabling firewalls on BSDRP 1.90 (FreeBSD 11.2-BETA3) forwarding performance
  - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 at 2.4GHz)
  - Quad port Chelsio 10-Gigabit T540-CR (10Giga DAC cable)
  - 5000 flows of smallest UDP packets
  - Minimum firewall rules
  - 2 static routes
  - harvest.mask=351
  - Traffic load at 14.88 Mpps
  - Yandex patches applied (AFDATA lock, RADIX lock) and pf MFC

![Impact of enabling firewalls on BSDRP 1.90 forwarding performance](graph.png)

