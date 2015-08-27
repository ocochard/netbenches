# netbenchs
Network forwarding performance benchmark results

This repository includes bench scripts, bench configuration files, raw results and graphs on few setups.

 - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled), dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
    - FreeBSD 10.2
	   - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.2] (Xeon_L5630-4Cores-Intel_82599EB/fastforwarding-pf-ipfw/results/fbsd10.2/README.md)
       - [Impact of number of static routes on forwarding performance on FreeBSD 10.2] (Xeon_L5630-4Cores-Intel_82599EB/route-contention/results/fbsd10.2/README.md)
    - FreeBSD 10.1
    - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.1] (Xeon_L5630-4Cores-Intel_82599EB/fastforwarding-pf-ipfw/results/fbsd10.1/README.md)
 - HP
	- FreeBSD 10.2
      - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.2] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd10.2/README.md)
      - [Impact of Chelsio rx/tx queue number on forwarding performance on FreeBSD 10.2] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g/results/fbsd10.2/README.md)
    - FreeBSD 10.1
      - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.1] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd10.1/README.md)
