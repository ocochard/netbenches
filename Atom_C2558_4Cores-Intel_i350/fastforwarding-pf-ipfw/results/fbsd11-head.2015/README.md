One year (2015) of fastforwarding performance evolution with ipfw/pf impact
Comparing benefit of patch D3737 on forwarding performance
  - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E)
  - Quad port Intel i350
  - FreeBSD 11 head: one revision per week (last of sunday, or last of monday if build failed)
  - 2000 flows of smallest UDP packets
  - Traffic load at 1.448Mpps (Gigabit line-rate)
  - Kernel: GENERIC-NODEBUG
  - harvest.mask=351

![One year (2015) of fastforwarding performance evolution with ipfw/pf impact](graph.png)
