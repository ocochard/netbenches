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

cat <<EOF
#!/bin/sh
fwcmd="/sbin/ipfw"
# Flush out the list before we begin.
\${fwcmd} -f flush
EOF

count=0
for j in $(jot 255); do
	for i in $(jot 255); do
		echo "\${fwcmd} add deny ip from 1.$j.$i.0/24 to any"
		count=$((count + 1))
		[ ${count} -eq ${max} ] && break 2
	done
done
echo "\${fwcmd} add allow ip from any to any"
