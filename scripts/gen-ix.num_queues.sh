#!/bin/sh
# Generate all configurations from the -default
set -eu
templatedir="16-default"
if [ ! -d ${templatedir} ]; then
	echo "No folder ${templatedir}"
	exit 1
fi

for queue in $(jot 24); do
	if [ ${queue} -ne 16 ]; then
		[ -d $queue ] && rm -rf $queue
		cp -r ${templatedir} $queue
		cat <<EOF >> $queue/boot/loader.conf.local

# Limiting number of queue to ${queue}
hw.ix.num_queues="${queue}"
# IFLIB version
dev.ix.0.iflib.override_nrxqs="${queue}"
dev.ix.0.iflib.override_ntxqs="${queue}"
EOF
	fi
done
