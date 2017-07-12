#!/bin/sh
# From unique gnuplot.data file, split into multiples files
# (one day I will learn how to do it directly from gnuplot)
set -eu

if ! [ -f $1 ]; then
	echo "Need path to gnuplot.data filename as argument"
	exit 1
fi

dataset='
forwarding.inet4
forwarding.inet6
ipf-stateful.inet4
ipf-stateful.inet6
ipf-stateless.inet4
ipfw-stateful.inet6
ipfw-stateless.inet4
ipfw-stateless.inet6
pf-stateful.inet4
pf-stateful.inet6
pf-stateless.inet4
'

for i in $dataset; do
	echo $i
	echo "#index median minimum maximum" > $i.data
	grep "\.$i" gnuplot.data | sed s/.$i// > $i.data
done
