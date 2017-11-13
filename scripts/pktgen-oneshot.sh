#!/bin/sh
set -eu

SSH_USER="root"
SSH_CMD="/usr/bin/ssh -x -a -q -2 -o \"ConnectTimeout=120\" -o \"PreferredAuthentications publickey\" -o \"StrictHostKeyChecking no\" -l ${SSH_USER}"

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


[ -f "$1" ] && . $1 || die "Need lab config file"

PKT_TO_SEND=0
RECEIVER_START_CMD="pkt-gen -N -f rx -i ${RECEIVER_LAB_IF} -w 4"
RECEIVER_STOP_CMD="pkill pkt-gen"
SENDER_START_CMD="pkt-gen -N -f tx -i ${SENDER_LAB_IF} -n ${PKT_TO_SEND} \
-${AF} -d ${RECEIVER_LAB_NET} -D ${DUT_LAB_IF_MAC_SENDER_SIDE} -T 2000 \
-s ${SENDER_LAB_NET} -S ${SENDER_LAB_IF_MAC} -w 4 -p 2 -l ${PKT_SIZE}"

rcmd ${RECEIVER_ADMIN} "${RECEIVER_STOP_CMD}" || true

trap "echo 'Running exit trap code' ; rcmd ${RECEIVER_ADMIN} \"${RECEIVER_STOP_CMD}\"" 1 2 15 EXIT
echo "Starting one-shot bench lab, press Crtl+C for exit"
rcmd ${RECEIVER_ADMIN} "${RECEIVER_START_CMD}" > /tmp/receiver.txt 2>&1 &
rcmd ${SENDER_ADMIN} "${SENDER_START_CMD}" > /tmp/sender.txt 2>&1 &
tail -f /tmp/receiver.txt
