#!/bin/sh
# Generate all configurations from the 24-default
set -eu
templatedir="8-default"
if [ ! -d ${templatedir} ]; then
	echo "No folder ${templatedir}"
	exit 1
fi

for queue in $(jot 24); do
	if [ ${queue} -ne 8 ]; then
		[ -d $queue ] && rm -rf $queue
		cp -r ${templatedir} $queue
		cat <<EOF >> $queue/boot/loader.conf.local

# Limiting number of queue to ${queue}
hw.cxgbe.nrxq="${queue}"
hw.cxgbe.ntxq="${queue}"
hw.cxgbe.nrxq10g="${queue}"
hw.cxgbe.ntxq10g="${queue}"
EOF
	fi
done
