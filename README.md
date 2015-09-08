# netbenchs
Network forwarding performance benchmark results

This repository includes bench scripts, bench configuration files, raw results and graphs on few setups.

 - IBM System x3550 M3 with quad cores (Intel Xeon L5630 2.13GHz, hyper-threading disabled), dual port Intel 82599EB 10-Gigabit and OPT SFP (SFP-10G-LR)
    - FreeBSD project/routing
       - [Impact of queue number on forwarding performance on FreeBSD project/routing r287531] (Xeon_L5630-4Cores-Intel_82599EB/ix.num_queues/results/fbsd11-melifaro.r287531/README.md)
    - FreeBSD head r287478
       - [Impact of queue number on forwarding performance on FreeBSD head r287478] (Xeon_L5630-4Cores-Intel_82599EB/ix.num_queues/results/fbsd11-head.r287478/README.md)
    - FreeBSD 10.2
	   - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.2] (Xeon_L5630-4Cores-Intel_82599EB/fastforwarding-pf-ipfw/results/fbsd10.2/README.md)
       - [Impact of number of static routes on forwarding performance on FreeBSD 10.2] (Xeon_L5630-4Cores-Intel_82599EB/route-contention/results/fbsd10.2/README.md)
       - [Impact of queue number on forwarding performance on FreeBSD 10.2] (Xeon_L5630-4Cores-Intel_82599EB/ix.num_queues/results/fbsd10.2/README.md)
    - FreeBSD 10.1
    - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.1] (Xeon_L5630-4Cores-Intel_82599EB/fastforwarding-pf-ipfw/results/fbsd10.1/README.md)
 - HP ProLiant DL360p Gen8 (8 cores Intel Xeon E5-2650 @ 2.60GHz) with 10-Gigabit Chelsio T540-CR
    - FreeBSD head project/routing
      - [Impact of Chelsio rx/tx queue number on forwarding performance on FreeBSD project/routing r287531] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g/results/fbsd11-melifaro.r287531/README.md)
    - FreeBSD head r287478
	  - [Impact of Chelsio rx/tx queue number on forwarding performance on FreeBSD head r287478] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g/results/fbsd11-head.r287478/README.md)
	- FreeBSD 10.2
      - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.2] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd10.2/README.md)
      - [Impact of Chelsio rx/tx queue number on forwarding performancei on FreeBSD 10.2] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/nXxq10g/results/fbsd10.2/README.md)
      - [Impact of reducinq rx/tx queues to 4 and pf/ipfw on forwarding performance on FreeBSD 10.2] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw.4nxq10g/results/fbsd10.2/README.md)
    - FreeBSD 10.1
      - [Impact of enabling ipfw or pf on forwarding performance on FreeBSD 10.1] (Xeon_E5-2650-8Cores-Chelsio_T540-CR/fastforwarding-pf-ipfw/results/fbsd10.1/README.md)
