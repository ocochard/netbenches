#!/bin/sh
#
# Bench-lab for BSD Router Project
# http://bsdrp.net/documentation/examples/freebsd_performance_regression_lab
#
# Purpose:
#  This script permit to automatize benching multiple BSDRP images and/or configuration parameters.
#  In a lab like this one (simple forwarding/firewalling):
#  +----------+     +-------------------------+     +----------+
#  | Sender   |<--->| Device Under Test (DUT) |<--->| Receiver |
#  +----------+     +-------------------------+     +----------+
#      |                       |                         |
#    -----------------admin network (ssh)--------------------
#
#  Or this one (IPSec or tunnel):
#
#    -----------------admin network (ssh)--------------------
#      |                      |                         |
#  +----------+     +-------------------------+    +-----------+
#  | Sender   |---->| Device Under Test (DUT) |--->| Reference |
#  | Receiver |     |                         |    | Endpoint  |
#  +----------+     +-------------------------+    +-----------+
#      |                                                |
#      -----<--------------------------------------------
#
#  this script permit to:
#  1. change configuration or upgrade image of the DUT (BSDRP based) and reboot it
#  2. once rebooted, generate traffic and collect the result
#  All commands are ssh.
#

set -eu

##### User modifiable variables section #####
# SSH Command line
SSH_USER="root"
SSH_CMD="/usr/bin/ssh -x -a -q -2 -o \"ConnectTimeout=120\" -o \"PreferredAuthentications publickey\" -o \"StrictHostKeyChecking no\" -l ${SSH_USER}"

###### End of user modifiable variable section #####

# Counting for running bench
BENCH_RUNNING_COUNTER=1
# Bench configuration file
CONFIG_FILE=''
# Directory containing configuration sets
CONFIG_SET_DIR=''
# Directory containing nanobsd upgrade image
IMAGES_DIR=''
# Directory containing pkg-gen configuration file
PKTGEN_DIR=''
# Directory containing Bench results
RESULTS_DIR="/tmp/benchs"
# Number of iteration for the same tests (for filling ministat)
BENCH_ITER=5
# Counting total number of tests bench
BENCH_ITER_TOTAL=0
# Report's email receiver
MAIL="root@localhost"
# PMC mode (collect hwpmc data)
PMC=false

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }


rcmd () {
	# Send remote command
	# $1: hostname
	# $2: command to send
	# return 0 if OK, 1 if not
	# Need to echap with '', because pkt-gen argument includes ""
	# but this break cat file | rcmd $1 $2
	eval ${SSH_CMD} $1 \'$2\' && return 0 || return 1
}

reboot_host () {
	# Reboot host $1 (DUT_ADMIN or REF_ADMIN)
	# Need to wait an online return before continuing too
	echo -n "Rebooting $1 and waiting device return online..."
	# WARNING: If configuration was not saved, it will ask user for configuration saving
	rcmd $1 'shutdown -r +1s' > /dev/null 2>&1
	sleep 20
	#wait-for-dut online and in forwarding mode
	local TIMEOUT=${REBOOT_TIMEOUT}
	while ! rcmd $1 "netstat -rn" > /dev/null 2>&1; do
		sleep 5
		TIMEOUT=$(( ${TIMEOUT} - 1 ))
		[ ${TIMEOUT} -eq 0 ] && die "$1 not reachable mode after $(( ${REBOOT_TIMEOUT} * 5 )) seconds"
	done
	echo "done"
	return 0
}

bench_image () {
	# Start to bench a list of images
	# $1: Directory/prefix-name of output log file

	if [ -n "${IMAGES_DIR}" ]; then
		for IMAGE in $(ls -1 ${IMAGES_DIR}/BSDRP-* | egrep 'upgrade.*\.img($|\.xz)'); do
			(${COUNTING}) || echo "Start firmware image set: ${IMAGE}"
			# When using multiple image, they are using svn revision number in their filename like:
			# BSDRP-293643-upgrade-amd64-serial.img.xz
			# BSDRP-294235-upgrade-amd64-serial.img.xz
			# Use this revision as prefix for the next bench set
			IMAGE_PREFIX=`basename ${IMAGE} | cut -d '-' -f 2`
			[ -z "${IMAGE_PREFIX}" ] &&  IMAGE_PREFIX=`basename ${IMAGE}`
			(${COUNTING}) || upgrade_image ${IMAGE} || die "Can't upgrade to image ${IMAGE}"
			# It's not possible to do an upgrade_image and pushing new CFG in one time
			# because if new CFG include /boot change, it will save change on the old partition
			# Then we need to force a reboot here
			(${COUNTING}) || reboot_host ${DUT_ADMIN}

			bench_cfg $1.${IMAGE_PREFIX}
		done
	else
		IMAGE_PREFIX=""
		bench_cfg $1
	fi
}

bench_cfg () {
	# Bench a list of configurations
	# $1: Directory/prefix-name of output log file

	if [ -n "${CONFIG_SET_DIR}" ]; then
		for CFG in $(ls -1d ${CONFIG_SET_DIR}/*); do
			CFG_PREFIX=$(basename ${CFG})
			[ "${CFG_PREFIX}" = "dut" -o "${CFG_PREFIX}" = "refendpoint" ] && die "Wrong config set directory: use upper dir"
			(${COUNTING}) || echo "Start configuration set: ${CFG_PREFIX}"
			if [ -d ${CFG}/dut -a -d ${CFG}/refendpoint ]; then
				(${COUNTING}) || upload_cfg ${CFG}/dut ${DUT_ADMIN} || die "Can't upload ${CFG}/dut to ${DUT_ADMIN}"
				(${COUNTING}) || upload_cfg ${CFG}/refendpoint ${REF_ADMIN} || die "Can't upload ${CFG}/refendpoint to ${REF_ADMIN}"
				# TO DO: should reboot ref_admin in background and not wait before rebooting dut_admin
				(${COUNTING}) || reboot_host ${REF_ADMIN}
			else
				(${COUNTING}) || upload_cfg ${CFG} ${DUT_ADMIN} || die "Can't upload ${CFG} to ${DUT_ADMIN}"
			fi
			(${COUNTING}) || reboot_host ${DUT_ADMIN}
			bench_pktgen $1.${CFG_PREFIX}
		done
	else
		CFG_PREFIX=""
		bench_pktgen $1
	fi

}

bench_pktgen () {
	# Multiple pkt-gen configuration (multiple differents number of flows)
	# $1: Directory/prefix-name of output log file

	if [ -n "${PKTGEN_DIR}" ]; then
		for PKTGEN_CFG in `ls -1d ${PKTGEN_DIR}/*`; do
			(${COUNTING}) || echo "Start pkt-gen set: ${PKTGEN_CFG}"
			# Load new netmap pkt-gen variables
			. ${PKTGEN_CFG}
			# Then need to reload new configuration file too
			. ${CONFIG_FILE}
			PKTGEN_PREFIX=`basename ${PKTGEN_CFG}`
			bench_iter $1.${PKTGEN_PREFIX}
		done
	else
		PKTGEN_PREFIX=""
		bench_iter $1
	fi
}

bench_iter () {
	# Iteration function
	# $1 prefix-name
	if !(${COUNTING}); then
		echo "IMAGE=\"${IMAGE_PREFIX}\"" > $1.info
		echo "CFG=\"${CFG_PREFIX}\"" >> $1.info
		echo "PKTGEN=\"${PKTGEN_PREFIX}\"" >> $1.info
		echo -n "UNAME=\"`rcmd ${DUT_ADMIN} "uname -a"`\"" >> $1.info
	fi

	BENCH_ITER_COUNTER=0
	for ITER in `seq 1 ${BENCH_ITER}`; do
		if (${COUNTING}); then
			#Increment the TOTAL counter only in COUNTING mode
			BENCH_ITER_TOTAL=$(( ${BENCH_ITER_TOTAL} + 1 ))
		else
			#And start bench otherwise
			bench $1.${ITER}
		fi
	done
}

bench () {
	# Benching script
	# $1: Directory/prefix-name of output log file
	echo "Start bench serie `basename $1`"
	if ($PMC); then
		rcmd ${DUT_ADMIN} "kldstat -qm hwpmc || kldload hwpmc" || die "Can't load hwmpc"
		rcmd ${DUT_ADMIN} "mount | grep -q '/data' || mount /data" || die "Can't mount /data"
		rcmd ${DUT_ADMIN} "pmcstat -S ${PMC_EVENT} -l 20 -O /data/pmc.out" >> $1.pmc.log &
		JOB_PMC=$!
	fi
	#start receiving tool on RECEIVER
	if [ -n "${RECEIVER_START_CMD}" ]; then
		echo "CMD: ${RECEIVER_START_CMD}" > $1.receiver
		rcmd ${RECEIVER_ADMIN} "${RECEIVER_START_CMD}" >> $1.receiver 2>&1 &
		#JOB_RECEIVER=$!
	fi
	#Alternate method with log file stored on RECEIVER (if tool is verbose)
	#rcmd ${RECEIVER_ADMIN} "nohup netreceive 9090 \>\& /tmp/bench.log.receiver \&"
	echo "CMD: ${SENDER_START_CMD}" > $1.sender
	rcmd ${SENDER_ADMIN} "${SENDER_START_CMD}" >> $1.sender 2>&1 &
	JOB_SENDER=$!
	echo -n "Waiting for end of bench ${BENCH_RUNNING_COUNTER}/${BENCH_ITER_TOTAL}..."
	#if echo ${SENDER_START_CMD} | grep -q pkt-gen; then
		# There is a bug with pkt-gen: It can sometime never end after finishing sending all packets,
		# because stuck at "sender_body [1214] pending tx tail 511 head 2047 on ring 2"
		# Then this simple wait command didn't works:
		#wait ${JOB_SENDER}
		# in place, will look every 2 second for "flush tail" in the sender log
	#	while true; do
	#		sleep 2
	#		grep -q 'flush tail' $1.sender && break
	#	done
	#else
		wait ${JOB_SENDER}
	#fi
	if [ -n "${RECEIVER_STOP_CMD}" ]; then
		rcmd ${RECEIVER_ADMIN} "${RECEIVER_STOP_CMD}" || echo "DEBUG: Can't kill pkt-gen"
	fi

	#scp ${RECEIVER_ADMIN}:/tmp/bench.log.receiver $1.receiver
	#kill ${JOB_RECEIVER}

	if ($PMC); then
		wait ${JOB_PMC}
		rcmd ${DUT_ADMIN} "pmcstat -R /data/pmc.out -z16 -G /data/pmc.graph" >> $1.pmc.log || die "can't convert pmc.out to pmc.graph"
		scp ${SSH_USER}@${DUT_ADMIN}:/data/pmc.out $1.pmc.out >> $1.pmc.log 2>&1 || die "can't download pmc.out"
		scp ${SSH_USER}@${DUT_ADMIN}:/data/pmc.graph $1.pmc.graph >> $1.pmc.log 2>&1 || die "can't download pmc.graph"
		rcmd ${DUT_ADMIN} "rm /data/pmc.out && rm /data/pmc.graph && umount /data" >> $1.pmc.log || echo "Can't delete old data files"
	fi

	echo "done"

	# if we did the last test of all, we can exit (avoid to wait for an useless reboot)
	[ ${BENCH_RUNNING_COUNTER} -eq ${BENCH_ITER_TOTAL} ] && return 0

	BENCH_RUNNING_COUNTER=$(( ${BENCH_RUNNING_COUNTER} + 1 ))

	# if we did the last test of the serie, we can exit and avoid an useless reboot
	# because after this last, it will be rebooted outside this function
	[ ${BENCH_ITER_COUNTER} -eq ${BENCH_ITER} ] && return 0

	reboot_host ${DUT_ADMIN}
	return 0
}

upload_cfg () {
	# Uploading configuration to the DUT
	# $1: Path to the directory that contains configuration files
	# $2: Device to upload to (DUT_ADMIN or REF_ADMIN)
	echo "Uploading cfg $1 to $2"
	if [ -d $1/boot ]; then
		# Before putting file in /boot, we need to remount in RW mode
		if ! rcmd $2 "mount -uw /" > /dev/null 2>&1; then
			return 1
		fi
	fi
	if ! scp -r -2 -o "PreferredAuthentications publickey" -o "StrictHostKeyChecking no" $1/* root@$2:/ > /dev/null 2>&1; then
		return 1
	fi
	if rcmd $2 "config save" > /dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

icmp_test_all () {
	# Test if we can ping all devices
	local PING_ACCESS_OK=true
	echo "Testing ICMP connectivity to each devices:"
	# TO DO: REF_ADMIN
	for HOST in ${SENDER_ADMIN} ${RECEIVER_ADMIN} ${DUT_ADMIN} ${REF_ADMIN}; do
		if [ -n "${HOST}" ]; then
			echo -n "  ${HOST}..."
			if ping -c 2 ${HOST} > /dev/null 2>&1; then
				echo "OK"
			else
				echo "NOK"
				PING_ACCESS_OK=false
			fi
		fi
	done
	( ${PING_ACCESS_OK} ) && return 0 || return 1
}

ssh_push_key () {
	# Pushing ssh key
	echo "Testing SSH connectivity with key to each devices:"
	for HOST in ${SENDER_ADMIN} ${RECEIVER_ADMIN} ${DUT_ADMIN} ${REF_ADMIN}; do
		if [ -n "${HOST}" ]; then
			echo -n "  ${HOST}..."
			if ! rcmd ${HOST} "uname" > /dev/null 2>&1; then
				echo ""
				echo -n "    Pushing ssh key to ${HOST}..."
				# TO DO: use ssh-copy-id
				if [ -f ~/.ssh/id_rsa.pub ]; then
					cat ~/.ssh/id_rsa.pub | ssh -2 -q -o "StrictHostKeyChecking no" root@${HOST} "cat >> ~/.ssh/authorized_keys" > /dev/null 2>&1
				elif [ -f ~/.ssh/id_dsa.pub ]; then
					cat ~/.ssh/id_dsa.pub | ssh -2 -q -o "StrictHostKeyChecking no" root@${HOST} "cat >> ~/.ssh/authorized_keys" > /dev/null 2>&1
				else
					echo "NOK"
					die "Didn't found user public SSH key"
				fi
			else
				echo "OK"
			fi
		fi
	done
	return 0
}

upgrade_image () {
	# Upgrade remote image
	# $1 Full path to the image
	echo -n "Upgrading..."
	if echo "$1" | grep -q ".img.xz"; then
		cat $1 | rcmd ${DUT_ADMIN} 'xzcat | upgrade' > /dev/null 2>&1
	else
		cat $1 | rcmd ${DUT_ADMIN} 'cat | upgrade' > /dev/null 2>&1
	fi
	# check for "Upgrade complete" in dmesg
	if rcmd ${DUT_ADMIN} 'grep -q "Upgrade complete" /var/log/messages'; then
		echo "done"
		return 0
	else
		echo "failed"
		return 1
	fi
}

usage () {
	if [ $# -lt 1 ]; then
		echo "$0 [-h] [-f bench-lab-config] [-c configuration-sets-dir] [-i nanobsd-images-dir]"
		echo "   [-n iteration] [-p pktgen cfg dir ] [-d benchs-results-dir] [-P] -r e@mail"
		echo "
 -f bench-lab-config:        Text file with lab bench parameters (mandatory)
 -i nanobsd-images-dir:      Directory where are stored nanobsd update images (optional)
 -c configuration-sets-dir:  Directory where are stored configuration sets (optional)
 -p pkgen-cfg-dir:           Directory where specific pkt-gen parameters are (optional)
 -n iteration:               Number of iteration to do for each bench (3 minimums, 5 by default)
 -d benchs-results-dir:      Directory Where to store benches results (/tmp/benchs by default)
 -r e@mail:                  Email to send report too at the end (default root@localhost)
 -P :                        PMC collection mode"
		exit 1
	fi
}

##### Main

args=`getopt c:d:f:i:hn:r:Pp: $*`

set -- $args
for i
do
	case "$i" in
	-c)
		CONFIG_SET_DIR=$2
		shift
		shift
		;;
	-d)
		RESULTS_DIR="$2"
		shift
		shift
		;;
	-f)
		CONFIG_FILE="$2"
		shift
		shift
		;;
        -i)
		IMAGES_DIR="$2"
		shift
		shift
		;;
	-h)
		usage
		shift
		;;
	-n)
		(${PMC}) || BENCH_ITER=$2
		shift
		shift
		;;
	-r)
		MAIL="$2"
		shift
		shift
		;;
	-p)
		PKTGEN_DIR="$2"
		shift
		shift
		;;
	-P)
		BENCH_ITER=1
		PMC=true
		shift
		;;
	--)
		shift
		break
        esac
done

if [ $# -gt 0 ] ; then
    echo "$0: Extraneous arguments supplied"
    usage
fi

#### Checking user input ####
[ -z  "${CONFIG_FILE}" ] && die "No configuration file given: -f is mandatory"
[ -f ${CONFIG_FILE} ] || die "Can't found configuration file"
[ -n ${PKTGEN_DIR} ] && [ -d ${PKTGEN_DIR} ] || die "Can't found directory ${PKTGEN_DIR}"
[ -n ${IMAGES_DIR} ] && [ -d ${IMAGES_DIR} ] || die "Can't found directory ${IMAGES_DIR}"
[ -n ${RESULTS_DIR} ] && [ -d ${RESULTS_DIR} ] || die "Can't found directory ${RESULTS_DIR}"
[ -n ${CONFIG_SET_DIR} ] && [ -d ${CONFIG_SET_DIR} ] || die "Can't found directory ${CONFIG_SET_DIR}"
!($PMC) && [ ${BENCH_ITER} -lt 3 ] && die "Need a minimum of 3 series of benchs"

# Load (first time) the configuration set
. ${CONFIG_FILE}

# Calculating the number of test to do

COUNTING=true
bench_image ${RESULTS_DIR}/bench

#echo "Total bench: ${BENCH_ITER_TOTAL}"
#exit 1

echo "BSDRP automatized upgrade/configuration-sets/benchs script"
echo ""
echo "This script will start ${BENCH_ITER_TOTAL} bench tests using:"
echo -n " - Multiples images to test: "
[ -z "${IMAGES_DIR}" ] && echo "no" || echo "yes"
echo -n " - Multiples configuration-sets to test: "
[ -z "${CONFIG_SET_DIR}" ] && echo "no" || echo "yes"
echo -n " - Multiples pkt-gen configuration to test: "
[ -z "${PKTGEN_DIR}" ] && echo "no" || echo "yes"
echo " - Number of iteration for each set: ${BENCH_ITER}"
echo " - Results dir: ${RESULTS_DIR}"
(${PMC}) && echo " - PMC mode: Will collect PMC data"
echo ""

ls ${RESULTS_DIR} | grep -q bench && die "You really should clean-up all previous reports in ${RESULTS_DIR} before to mismatch your differents results"


echo -n "Do you want to continue ? (y/n): "
USER_CONFIRM=''
while [ "$USER_CONFIRM" != "y" -a "$USER_CONFIRM" != "n" ]; do
	read USER_CONFIRM <&1
done
[ "$USER_CONFIRM" = "n" ] && exit 0

icmp_test_all || die "ICMP connectivity test failed"
ssh-add -l > /dev/null 2 || echo "WARNING: No key loaded in ssh-agent?"
ssh_push_key || ( echo "SSH connectivity test failed";exit 1 )

MAILFILE=`mktemp /tmp/bench-mail.XXXXXX` || die "can't create tmp/bench-mail.xxx"

echo "Bench started at:" >> ${MAILFILE}
echo `date` >> ${MAILFILE}

echo "Starting the benchs"
# bench_image => bench_cfg => bench_pktgen => bench

COUNTING=false
bench_image ${RESULTS_DIR}/bench

echo "All bench tests were done, results in ${RESULTS_DIR}"

echo "Bench end at:" >> ${MAILFILE}
echo `date` >> ${MAILFILE}
mail -s "Benchs ${RESULTS_DIR} Done" ${MAIL} < ${MAILFILE}
[ -f ${MAILFILE} ] && rm ${MAILFILE}
