# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png truecolor size 1920,1080 font "Gill Sans,22"
set output 'graph.png'
#set terminal svg size 1024,768 font "Gill Sans,12" rounded dashed
#set output 'graph.svg'

# Line style for axes
set style line 80 lt 0
set style line 80 lt rgb "#808080"

# Line style for grid
set style line 81 lt 3  # dashed
set style line 81 lt rgb "#808080" lw 0.5  # grey

# add a slight grid to make it easier to follow the exact position of the curves
set grid back linestyle 81

# Remove border on top and right.
# These borders are useless and make it harder to see plotted lines near the border.
# Also, put it in grey; no need for so much emphasis on a border.
set border 3 back linestyle 80

# nomirror means do not put tics on the opposite side of the plot
set tics nomirror

# Line styles: try to pick pleasing colors, rather
# than strictly primary colors or hard-to-see colors
# like gnuplot's default yellow.  Make the lines thick
# so they're easy to see in small plots in papers.
set style line 1 lt 1
set style line 2 lt 1
set style line 3 lt 1
set style line 4 lt 1
set style line 1 lt rgb "#A00000" lw 2 pt 7
set style line 2 lt rgb "#00A000" lw 2 pt 9
set style line 3 lt rgb "#5060D0" lw 2 pt 5
set style line 4 lt rgb "#F25900" lw 2 pt 13

# Fill box and width
#set bars fullwidth
set style fill solid 1.0 border -1
set style histogram errorbars gap 2 lw 2
set boxwidth 0.9 relative
# Draw a corresponding IMIX Eth throughput estimation on the right side
set y2tics
# IMIX: packet * ( 7*(40+14) + 4*(576+14) + (1500+14))/12*8 = 2834.666667
set link y2 via y * 2834.666667 inverse y/2834.666667
# Replace long value by M (million), K (kilo) on ytics
#set ytics format '%.0s%c'
set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s'

# Only integer value for xtics
set xtics 1

set title noenhanced "Impact of enabling firewalls on BSDRP 1.991 (FreeBSD 14-head c276570) forwarding performance\nDell R630 with 2x12 cores Intel Xeon E5 2650 and 10G Intel 82599ES"
set xlabel "Note: Minimum firewall rules, ICMP redirect disabled, 16rxq"
set ylabel "Packets per second (minimum size, 5000 flows)\n minimum,median,maximum values of 5 benches"
set y2label "Theorical equity using simple IMIX distribution (Ethernet throughput)"

# Put the label inside the graph
set key on inside top right

f(x)=14880000
h(x)=7000000
# Ploting!
plot "inet4.data" using 2:3:4:xticlabels(1) with histogram title "inet4" ls 2, \
	 "inet6.data" using 2:3:4:xticlabels(1) with histogram title "inet6" ls 3, \
     f(x) with lines title "10 Gigabit line-rate" ls 1 lw 4, \
	h(x) with lines title "Min req for 10G FDX with simple IMIX" ls 5 lw 4
