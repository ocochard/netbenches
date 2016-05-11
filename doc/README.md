# FreeBSD network benchmark script #

## Objectives ##

Theses two shell script allows to automate large number of network performance benches.
They work on FreeBSD, because created for [BSD Router Project](http://bsdrp.net) but should be easly ported to other OS.

They allow to generate performance regression of multiple FreeBSD release (using multiple nanobsd image files) and multiple configuration set for giving this example:
![One year (2015) of fastforwarding performance evolution with ipfw/pf impact](../Atom_C2558_4Cores-Intel_i350/fastforwarding-pf-ipfw/results/fbsd11-head.2015/graph.png)

It allows to add multiple flows paterns (number of unidirectionnal flows, packet size) too.

## Prerequisit ##

List of prerequisit:
* One server with netmap compliant NIC as packet generator/receiver under FreeBSD with netmap pkt-gen compiled (found under /usr/src/tools/tools/netmap)
* One server as Device under Test (DUT). For using multiple DUT configuration set or multiple firmware image, it need to run nanobsd based system (like BSDRP).
* One server for running theses script (it can be the same as the packet generator/receiver)

[More details for seting-up a physical network lab here](http://bsdrp.net/documentation/examples/setting_up_a_forwarding_performance_benchmark_lab).

## Scripts Concepts ##

There are two shell scripts:
* [bench-lab.sh](../scripts/bench-lab.sh): Main script that start sequentially all benches
* [bench-lab-ministat.sh](../scripts/bench-lab-ministat.sh): Extract mathematically data from pkt-gen raw text output and generate gnuplot data file

The main script needs one parameters and allow multiples other:
```
bench-lab.sh [-h] [-f bench-lab-config] [-c configuration-sets-dir] [-i nanobsd-images-dir]
             [-n iteration] [-p pktgen cfg dir ] [-d benchs-results-dir] -r e@mail

 bench-lab-config:        Text file with lab bench parameters (mandatory)
 nanobsd-images-dir:      Directory where are stored nanobsd update images (optional)
 configuration-sets-dir:  Directory where are stored configuration sets (optional)
 pktgen-cfg-dir:          Directory where specific pkt-gen parameters are (optional)
 iteration:               Number of iteration to do for each bench (3 minimums, 5 by default)
 benchs-results-dir:      Directory Where to store benches results (default /tmp/benchs)
 e@mail:                  Email to send report too at the end (default root@localhost)

```
Once started, it will:

1. Ping and learn SSH fingerprint for each servers to connect to
2. Start the image-update loop (cylcing across each nanobsd-update-image)
3. Upgrade DUT with the next nanobsd image and reboot it
4. Entering the configuration-set loop (cycling across each configuration set)
5. Upload configuration set to the DUT and reboot it
6. Entering pktgen loop (cycling across each pkt-gen configuration set)
7. Loading pktgen configuration
8. Entering the bench loop (cycling across the number of iteration)
9. Start the bench by sending SSH command to the packet generator/receiver, reboot the DUT at the end
10. Cycle until the end of bench loop
11. Cycle until the end of pktgen loop
12. Cycle until the end of configuration-set loop
13. cylce until the end of image-update loop

All benches raw data (pkt-gen in sender and receiver mode) are stored in files named:
* benchs-results-dir/bench.IMAGE.CONFIGURATION.PKTGEN.ITERATION.receiver: Raw output of pkt-gen in receiver mode
* benchs-results-dir/bench.IMAGE.CONFIGURATION.PKTGEN.ITERATION.sender: Raw output of pkt-gen in sender mode
* benchs-results-dir/bench.IMAGE.CONFIGURATION.PKTGEN.ITERATION.info: Resume of this series

Once raw data files generated, they need to be processed: This is the purpose of the second script that:
1. Check for all .info files in the directory given in parameters
2. For each of them, extract the median value of the .receiver raw output file
3. Merge each median values for each iteration in a .pps (one value per line)
4. Generate a gnuplot data file using each .pps files

## Exemple of configuration files ##

Here are some script configuration files:
* [A bench-lab configuration file using one generator/receiver and one DUT](../AMD_G-T40E_2Cores_RTL8111E/bench-lab-2nodes.config)
* [A configuration sets folder](../AMD_G-T40E_2Cores_RTL8111E/fastforwarding-pf-ipfw/configs)
* [A pkt-gen configurations sets folder](../pktgen.configs/RFC2544/)
