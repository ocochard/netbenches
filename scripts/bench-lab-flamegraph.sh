#!/bin/sh
# Convert a bunch of *.pmc into *.svg using FlameGraph perl scripts
# https://github.com/brendangregg/FlameGraph
# Need perl and flamegraph installed
set -eu
dir=""
filter=""
found=false

usage () {
	echo "$0 result-directory filter"
	echo "example:"
	echo "$0 results/fbsd12-head.r318516.pmc/ sched_idletd"
	exit 0
}

flamegraph () {
	pkg info -e flamegraph || die "flamegraph package not installed"
	for i in ${dir}/*.graph; do
		found=true
		prefix=${i%.graph}
		if [ -z "${filter}" ]; then
			stackcollapse-pmc.pl $i > ${prefix}.stack
		else
			stackcollapse-pmc.pl $i | grep -v ${filter} > ${prefix}.stack
		fi
		flamegraph.pl ${prefix}.stack > ${prefix}.svg
	done
	($found) && echo "Done" || echo "No .graph files found"
}

### main function ###

if [ $# -lt 1 ] ; then
    echo "$0: Missing argument(s)"
    usage
fi

dir=$1
[ $# -eq 2 ] && filter=$2

flamegraph
