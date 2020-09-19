#!/bin/sh
# This script prepare the result from bench-lab.sh to be used by ministat and/or gnuplot
# 
set -eu

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }

data_2_ministat () {
	# Convert raw data file from bench-lab.sh for list
	# $1 : Input file
	# $2 : Prefix of the output file
	grep 'Estimated' $1 | cut -d ' ' -f 5 >> $2
	grep 'Estimated' $1 | cut -d ' ' -f 10 >> $2.max
	return 0
}

data_2_gnuplot () {
	# Now we will generate gnuplot.data
	# $1 : Input file
	# and contents like:
	# # index median minimum maximum
	# fastforwarding 554844.5 550613 569875
	# ipfw-statefull 977952 939800 1063901
	# pf-statefull 1022447 998915 1075438.5
	INDEX=`basename $1`
	[ -f ${LAB_RESULTS}/gnuplot.data ] || echo "#index median minimum maximum" > ${LAB_RESULTS}/gnuplot.data
	ministat -n $1.equilibrium | tail -n -1 | awk -vid=${INDEX} '{print id " " $5 " " $3 " " $4}' >> ${LAB_RESULTS}/gnuplot.data
	[ -f ${LAB_RESULTS}/gnuplot.data.max ] || echo "#index median minimum maximum" > ${LAB_RESULTS}/gnuplot.data.max
	ministat -n $1.equilibrium.max | tail -n -1 | awk -vid=${INDEX} '{print id " " $5 " " $3 " " $4}' >> ${LAB_RESULTS}/gnuplot.data.max

}

## main

SVN=''
CFG=''
CFG_LIST=''

[ $# -ne 1 ] && die "usage: $0 benchs-directory"
[ -d $1 ] || die "usage: $0 benchs-directory"

LAB_RESULTS="$1"
# Info: /tmp/benchs/bench.244900.fastforwarding.info

INFO_LIST=`ls -1 ${LAB_RESULTS}/*.info`
[ -z "${INFO_LIST}" ] && die "ERROR: No report files found in ${LAB_RESULTS}"

echo "Ministating results..."

rm ${LAB_RESULTS}/*.pps && echo "Deleting previous .pps files"
[ -f ${LAB_RESULTS}/gnuplot.data ] && rm ${LAB_RESULTS}/gnuplot.data
[ -f ${LAB_RESULTS}/gnuplot.data.max ] && rm ${LAB_RESULTS}/gnuplot.data.max

for INFO in ${INFO_LIST}; do
	# We just need to source it
	. ${INFO}
	# Now we've got theses variables:
	# IMAGE="299888" (or image file if SVN number not found)
	# CFG="fastforwarding"
	# PKTGEN=""
	# UNAME="FreeBSD SM 10.3-RELEASE-p2 F..."

	MINISTAT_FILE=`echo ${INFO} | sed "s/.info//" | sed "s/bench.//"`

	# Now need to generate ministat input file for each different REPORT
	#   if report is: /tmp/benchs/bench.1.1.info
	#   => list all file like /tmp/benchs/bench.1.1.*.sender
	DATA_LIST=`echo ${INFO} | sed 's/info/*.sender/g'`
	DATA_LIST=`ls -1 ${DATA_LIST}`
	# clean allready existing ministat
	[ -f ${LAB_RESULTS}/${MINISTAT_FILE} ] && rm ${LAB_RESULTS}/${MINISTAT_FILE}
	for DATA in ${DATA_LIST}; do
		data_2_ministat ${DATA} ${MINISTAT_FILE}.equilibrium
	done # for DATA
	data_2_gnuplot ${MINISTAT_FILE}
done # for REPORT

echo "Done"
exit
