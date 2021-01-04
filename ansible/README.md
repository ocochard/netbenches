Testing ansible to replace my posix shell scripts

For one bench
synthesis:
1. Bench preparation: pkt-gen(s) and pkt-receiver(s) configs upload & reboot
1.1 Variables specifics (bench 2 nodes: interfaces, MAC addresses, etc.)
2. Main loop: Number of iteration (5)
2.1 Sub loop: For each firmware to tests
2.2 Subsub loop: For each configuration sets (DUT and ref platform)
2.3 subsubsub loop: pkt-gen sets (IPv4 vs IPv6 vs number of flows)
3. Bench
3.0 : Wait for DUT ready (full BGP table or huge deny list loaded)
3.2 : PMC, start pmc collector on DUT
3.1 : start pkt-gen and store results on pkt-gen(s) & pkt-receiver(s)
3.3 : PMC, grap data from DUT

Variables:
Generics:
- family=forwarding/pf/ipfw/ipsec/ipsec/wireguard/etc.
- setup (dut and ref)=2-static-routes, X-millions-routes, IPSec cyphers
  - interfaces and MAC addresses impacts
- hardware (dut)= Select which pkt-gen & recv (and if we need multiples one) and
 reference device (VPN endpoint)

To be benched:
- version: nanobsd images list, phabricator review, FreeBSD rev
- specific tunned parameters?
- tool: pkt-gen, equilibrium, ngnix+wrk
- tool_parameters= Like number of flows (2K IPv4, 4K IPv4 & IPv6) for pkt-gen ?
				number of requests/client for wrk


Ansible:
- From DUT, need to deduce generator and receiver: So it is a DUT related variables
- From familiy, need to deduce optionnal endoints?
=> Dynamic inventory  (or dynamic existing host to group)?
   But need a static mapping somewher (if dut=apu2 and family=forwarding, then tx=ibm3, rx=ibm3 and endpoint=null)

How to loop ?

https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html

main loop:

group of servers:
- pkg-gen(s) group
- pkt-reicv(s) group
- DUT item

Current status:

ansible-playbook bench.yml -i apu2_forwarding  --check
ansible-playbook bench.yml -i apu2_forwarding
ansible-playbook learning_loop.yml -i apu2_forwarding

Documentations:
https://www.ansible.com/hubfs//AnsibleFest%20ATL%20Slide%20Decks/Using%20Ansible%20Tower%20to%20Automate%20Baremetal%20Benchmarking%20-%20AnsibleFest%202019%20-%20Final-1.pdf
https://www.ansible.com/using-ansible-tower-to-automate-baremetal-benchmarking

How Flex Ciii Uses Ansible Tower for Benchmarking
https://www.ansible.com/blog/how-flex-ciii-uses-ansible-tower-for-benchmarking

https://github.com/HASTE-project/ansible-benchmarking

Debug:
Display facts (does not include host variables):
ansible apu2 -i apu2_forwarding -m setup

Display host variables:
ansible -m debug -a "var=hostvars[inventory_hostname]" apu2 -i apu2_forwarding
