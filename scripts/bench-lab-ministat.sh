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
	local LINES=$(wc -l $1)
	LINES=$(echo ${LINES} | cut -d ' ' -f1)
	# Remove the first 15 lines (garbage or not good result) and the 10 last lines (bad result too)
	CLEAN_ONE=$(mktemp /tmp/clean.1.data.XXXXXX) || die "can't create /tmp/clean.1.data.xxxx"
	head -n $(expr ${LINES} - 10) $1 | tail -n $(expr ${LINES} - 10 - 15) > ${CLEAN_ONE}
	# Filter the output (still filtering "0 pps" lines in case of) and kept only the numbers:
	# example of good line:
	# 290.703575 main_thread [1441] 729113 pps (730571 pkts in 1002000 usec)
	CLEAN_TWO=$(mktemp /tmp/clean.2.data.XXXXXX) || die "can't create /tmp/clean.2.data.xxxx"
	grep -E 'main_thread[[:space:]]\[[[:digit:]]+\][[:space:]][1-9].*pps' ${CLEAN_ONE} | cut -d ' ' -f 4 > ${CLEAN_TWO}
	#Now we calculate the median value of this run with ministat
	ministat -n ${CLEAN_TWO} | tail -n -1 | tr -s ' ' | cut -d ' ' -f 5 >> $2
	rm ${CLEAN_ONE} ${CLEAN_TWO} || die "ERROR: can't delete clean.X.data.xxx"
	return 0
}

data_2_gnuplot () {
	# Now we will generate gnuplot.data
	# $1 : Input file
	# $2 : Prefix of the output file
	# and contents like:
	# # index median minimum maximum
	# fastforwarding 554844.5 550613 569875
	# ipfw-statefull 977952 939800 1063901
	# pf-statefull 1022447 998915 1075438.5
	INDEX=$(basename $1)
	[ -f ${LAB_RESULTS}/gnuplot.data ] || echo "#index median minimum maximum" > ${LAB_RESULTS}/gnuplot.data
	ministat -n $1.pps | tail -n -1 | awk -vid=${INDEX} '{print id " " $5 " " $3 " " $4}' >> ${LAB_RESULTS}/gnuplot.data

}

## main

SVN=''
CFG=''

[ $# -ne 1 ] && die "usage: $0 benchs-directory"
[ -d $1 ] || die "usage: $0 benchs-directory"

LAB_RESULTS="$1"
# Info: /tmp/benchs/bench.244900.fastforwarding.info

INFO_LIST=$(ls -1 ${LAB_RESULTS}/*.info)
[ -z "${INFO_LIST}" ] && die "ERROR: No report files found in ${LAB_RESULTS}"

echo "Ministating results..."

rm ${LAB_RESULTS}/*.pps && echo "Deleting previous .pps files"
[ -f ${LAB_RESULTS}/gnuplot.data ] && rm ${LAB_RESULTS}/gnuplot.data

for INFO in ${INFO_LIST}; do
	# We just need to source it
	. ${INFO}
	# Now we've got theses variables:
	# IMAGE="299888" (or image file if SVN number not found)
	# CFG="fastforwarding"
	# PKTGEN=""
	# UNAME="FreeBSD SM 10.3-RELEASE-p2 F..."
	
	#MINISTAT_FILE=$(basename ${INFO})
	MINISTAT_FILE=$(echo ${INFO} | sed "s/.info//" | sed "s/bench.//")

	# Now need to generate ministat input file for each different REPORT
	#   if report is: /tmp/benchs/bench.1.1.info
	#   => list all file like /tmp/benchs/bench.1.1.*.receiver
	DATA_LIST=$(echo ${INFO} | sed 's/info/*.receiver/g')
	DATA_LIST=$(ls -1 ${DATA_LIST})
	# clean allready existing ministat
	[ -f ${LAB_RESULTS}/${MINISTAT_FILE} ] && rm ${LAB_RESULTS}/${MINISTAT_FILE}
	for DATA in ${DATA_LIST}; do
		data_2_ministat ${DATA} ${MINISTAT_FILE}.pps
	done # for DATA
	data_2_gnuplot ${MINISTAT_FILE}
done # for REPORT

# Dirty patch
# Generetate multiple files per config setup
if [ -f ${LAB_RESULTS}/gnuplot.data ]; then
	if [ $(grep -c forwarding ${LAB_RESULTS}/gnuplot.data) -gt 1 ]; then
		echo "#index median minimum maximum" > ${LAB_RESULTS}/forwarding.data
		grep forwarding gnuplot.data | sed s/.forwarding//g >> ${LAB_RESULTS}/forwarding.data
	fi
	if [ $(grep -c pf-statefull ${LAB_RESULTS}/gnuplot.data) -gt 1 ]; then
		echo "#index median minimum maximum" > ${LAB_RESULTS}/pf.data
		grep pf-statefull gnuplot.data | sed s/.pf-statefull//g >> ${LAB_RESULTS}/pf.data
	fi
	if [ $(grep -c ipfw-statefull ${LAB_RESULTS}/gnuplot.data) -gt 1 ]; then
		echo "#index median minimum maximum" > ${LAB_RESULTS}/ipfw.data
		grep pf-statefull gnuplot.data | sed s/.pf-statefull//g >> ${LAB_RESULTS}/ipfw.data
	fi
fi

echo "Done"
exit
