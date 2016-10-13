# netbenches
FreeBSD network forwarding performance benchmark results

This repository includes bench scripts (need netmap pkt-gen and nanobsd like), bench configuration files, raw results and gnuplot graphs on few setups.
[Bench script documentation is available too] (doc/README.md).

Hardware benched are:
 - HP ProLiant DL360p Gen8 (8 cores Intel Xeon E5-2650 @ 2.60GHz) and 10-Gigabit Chelsio T540-CR
 - IBM System x3550 M3 (4 cores Intel Xeon L5630 2.13GHz, hyper-threading disabled) and dual port Intel 82599EB 10-Gigabit
 - SuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758) and 10-Gigabit Chelsio T540-CR
 - Netgate RCC-VE 4860 (4 cores Intel Atom C2558E) and quad port Intel i350 (the 2 Intel i211 are not benched)
 - PC Engines APU1D (2 cores AMD G-T40E 1 GHz) and 3 Realtek RTL8111E Gigabit NIC
 - PC Engines APU2C4 (4 cores AMD GX-412TC) and 4 Intel i210AT Gigabit NIC

Some results:
 - Impact of enabling ipfw or pf:
    - [Impact of enabling ipfw or pf on fastforwarding performance with 8 cores Xeon E5-2650] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd11-routing.r287531/README.md)
	- [One year (2015) of fastforwarding performance evolution with with 8 cores Xeon E5-2650] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd11-head.2015/README.md)
    - [Impact of enabling ipfw or pf on fastforwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/fastforwarding-pf-ipfw/results/fbsd11-routing.r287531/README.md)
    - [Impact of enabling ipfw or pf on fastforwarding performance with 8 cores Atom C2758] (Atom_C2758_8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/10.3/README.md)
    - [Impact of enabling ipfw or pf on fastforwarding performance with 4 cores Atom C2558E] (Atom_C2558_4Cores-Intel_i350/fastforwarding-pf-ipfw/results/fbsd11-routing.r287531/README.md)
    - [Impact of enabling ipfw or pf on fastforwarding performance with 2 cores AMD G-T40E] (AMD_G-T40E_2Cores_RTL8111E/fastforwarding-pf-ipfw/results/fbsd11.0/README.md)
    - [Impact of enabling ipfw or pf on fastforwarding performance with 4 cores AMD GX-412TC] (AMD_GX-412TC_4Cores_Intel_i210AT/fastforwarding-pf-ipfw/results/fbsd10.3/README.md)
    - [One year (2015) of fastforwarding performance evolution with 4 cores Atom C2558E] (Atom_C2558_4Cores-Intel_i350/fastforwarding-pf-ipfw/results/fbsd11-head.2015/README.md)

 - Impact of number of static routes:
    - [Impact of number of static routes on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/route-contention/results/fbsd10.2/README.md)
 - Chelsio NIC T540-CR tuning:
    - [Impact of Chelsio T540-CR queue number (1 queue per core) on forwarding performance with 8 cores Xeon E5-2650] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g/results/fbsd11-routing.r287531/README.md)
    - [Impact of Chelsio T540-CR queue number on forwarding performance with 8 cores Atom C2758] (Atom_C2758_8Cores-Chelsio_T540-CR/nXxq10g.random.harvest.mask.351/results/fbsd10.3/README.md)
    - [Impact of random.harvest.mask and Chelsio T540-CR queue number (1 queue per core) on forwarding performance with 8 cores Xeon E5-2650] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g.random.harvest.mask.351/results/fbsd11-routing.r287531/README.md)
    - [Impact of disabling cxgbe.toecaps_allowed on forwarding performance with 8 cores Xeon E5-2650] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/cxgbe.toecaps_allowed/results/fbsd11-routing.r287531/README.md)
 - Intel 82599EB NIC tuning:
    - [Impact of Intel 82599EB queue number (1 queue per core) on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/ix.num_queues/results/fbsd11-routing.r287531/README.md)	
    - [Impact of random.harvest.mask and Intel 82599EB queue number (1 queue per core) on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/ix.num_queues.random.harvest.mask.351/results/fbsd11-routing.r287531/README.md)
	- [Impact of Intel 82599EB AIM on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/ix.enable_aim/results/fbsd10.2/README.md)
    - [Impact of Intel 82599EB Rx|Tx process limit on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/Xx_process_limit/results/fbsd10.2/README.md)
    - [Impact of Intel 82599EB descriptors per queue on forwarding performance with 4 cores Xeon L5630] (Xeon_L5630-4Cores-Intel_82599EB/ix.Xxd/results/fbsd10.2/README.md)
 - Intel i350 tuning:
    - [Impact of Intel i350 queue number (1 queue per core) on forwarding performance with 4 cores Atom C2558E] (Atom_C2558_4Cores-Intel_i350/igb.num_queues/results/fbsd11-routing.r287531/README.md)
 - Packet filter (pf) tuning:
    - [Impact of number of flows with default pf setting on performance on FreeBSD 10.3] (Atom_C2558_4Cores-Intel_i350/pf-sessions/results/fbsd10.3/README.md)
    - [Impact of number of flows with 10M states pf setting on performance on FreeBSD 10.3] (Atom_C2558_4Cores-Intel_i350/pf-sessions/results/fbsd10.3.10M/README.md)
    - [Impact of pf.states_hashsize with default max 10K states with FreeBSD 10.3] (Atom_C2558_4Cores-Intel_i350/pf-states_hashsize/results/fbsd10.3.default10K/README.md)
    - [Impact of pf.states_hashsize with 4M max states with FreeBSD 10.3] (Atom_C2558_4Cores-Intel_i350/pf-states_hashsize/results/fbsd10.3.4Mstates/README.md)

 - IPSec performance:
    - [IPSec performance with 4 cores AMD GX-412TC (PC Engines APU2C4)] (AMD_GX-412TC_4Cores_Intel_i210AT/ipsec/results/fbsd11.0/README.md)
    - [IPSec performance with 2 cores AMD G-T40E (PC Engines APU1D)] (AMD_G-T40E_2Cores_RTL8111E/ipsec/results/fbsd11.0/README.md)

Synthesis:
  - ![Impact of enabling ipfw/pf on fastforwarding performance on FreeBSD 10.2 with differents hardware] (synthesis/hardware.png)

