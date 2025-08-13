#!/bin/sh
# Generate all firewalls configurations from the forwarding
set -eu
if [ ! -d forwarding ]; then
	echo "No folder forwarding"
	exit 1
fi

for firewall in ipf-stateful ipf-stateless; do
	[ -d $firewall ] && rm -rf $firewall
	cp -r forwarding $firewall
	cat <<EOF >> $firewall/etc/rc.conf

# Enabling ipf
ipfilter_enable="YES"
ipfilter_rules="/etc/ipf.rules"
EOF
done

cat <<EOF > ipf-stateful/etc/ipf.rules
pass in quick on lo0
pass out quick on lo0
pass in  proto icmp from any to any keep state
pass out proto icmp from any to any keep state
pass out proto udp from any to any keep state
pass out proto udp from any to any keep state
pass in proto tcp from any to any flags S/SAFR keep state
pass out proto tcp from any to any flags S/SAFR keep state
EOF

cat <<EOF > ipf-stateless/etc/ipf.rules
pass out all
pass in all
EOF

for firewall in ipfw-stateful ipfw-stateless; do
	[ -d $firewall ] && rm -rf $firewall
	cp -r forwarding $firewall
	cat <<EOF >> $firewall/etc/rc.conf

# Enabling ipfw
firewall_enable="YES"
firewall_script="/etc/ipfw.rules"
EOF
done

cat <<EOF > ipfw-stateful/etc/ipfw.rules
#!/bin/sh
fwcmd="/sbin/ipfw"
# Flush out the list before we begin.
\${fwcmd} -f flush
\${fwcmd} add 3000 allow ip from any to any keep-state
EOF

cat <<EOF > ipfw-stateless/etc/ipfw.rules
#!/bin/sh
fwcmd="/sbin/ipfw"
# Flush out the list before we begin.
\${fwcmd} -f flush
\${fwcmd} add 3000 allow ip from any to any
EOF

for firewall in pf-stateful pf-stateless; do
	[ -d $firewall ] && rm -rf $firewall
	cp -r forwarding $firewall
	cat <<EOF >> $firewall/etc/rc.conf

# Enabling pf
pf_enable="YES"
pf_rules="/etc/pf.conf"
EOF
done

cat <<EOF > pf-stateful/etc/pf.conf
set skip on lo0
pass
EOF

cat <<EOF > pf-stateless/etc/pf.conf
set skip on lo0
pass no state
EOF
