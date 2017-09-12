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

[ "$max" -eq 1 ] && die "Need to be more than 1"

#We add one more allow rule at the end
max=$((max - 1))

cat <<EOF
#!/bin/sh
fwcmd="/sbin/ipfw"
# Flush out the list before we begin.
\${fwcmd} -f flush
\${fwcmd} table 1 create type addr
EOF

count=0
for k in $(jot 255); do
	for j in $(jot 255); do
		for i in $(jot 255); do
			echo "\${fwcmd} table 1 add $k.$j.$i.0/24"
			count=$((count + 1))
			[ ${count} -eq ${max} ] && break 3
		done
	done
done
echo "\${fwcmd} add deny ip from table\(1\) to any"
echo "\${fwcmd} add allow ip from any to any"
