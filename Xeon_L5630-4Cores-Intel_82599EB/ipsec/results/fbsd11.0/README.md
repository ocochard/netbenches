IPSec performance
  - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled)
  - Quad port Intel 82580 
  - PC Engines APU1D (core AMD G-T40E)
  - harvest.mask=351
  - no authentication algorithm
  - 2000 flows of UDP packets
  - 500B UDP load => packet size: 528B => Ethernet frame size:542B
  - Methodology: http://www.mecs-press.org/ijcnis/ijcnis-v4-n9/IJCNIS-V4-N9-1.pdf

![IPSec performance with FreeBSD 11.0 on IBM x3550 MP (Intel Xeon L5630)](graph.png)


