#!/bin/sh
# Generate rules
# Input: number of deny rule to add
set -eu

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }

[ $# -ne 1 ] && die "usage: $0 number-of-rules"

max=$1

case $max in
    ''|*[!0-9]*) die "Not a number";;
    *) ;;
esac

#We add one more allow rule at the end
max=$((max - 1))

echo "set skip on lo0"
echo -n "table <t> const{"
count=0
for k in $(jot 255); do
	for j in $(jot 255); do
		for i in $(jot 255); do
			echo -n "$k.$j.$i.0/24"
			count=$((count + 1))
			[ ${count} -eq ${max} ] && break 3
			echo -n ,
		done
	done
done
echo }
echo "block quick from <t>"
echo "pass no state"
