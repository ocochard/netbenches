# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png size 1024,768
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
set style fill solid
#transparent pattern 4 bo
#solid 0.5 noborder
set boxwidth 0.8
# Draw a corresponding IMIX Eth throughput estimation on the right side
set y2tics
# IMIX: packet * ( 7*(40+14) + 4*(576+14) + (1500+14))/12*8 = 2834.666667
set link y2 via y * 2834.666667 inverse y/2834.666667
# Replace long value by M (million), K (kilo) on ytics
set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s' 


# Only integer value for xtics
set xtics 1

set title "Impact of enabling ipfw/pf on forwarding performance (HP ProLiant DL360p Gen8 with 8 cores Intel Xeon E5-2650)"
set xlabel "Note: Chelsio T540-CR with 4 queues, fastforwarding enabled for ipfw and pf benchs. 2 firewall rules only. harvest.mask=351"
set ylabel "Packets per second (minimum size, 2000 flows)\n minimum,median,maximum values of 5 benchs"
set y2label "Theorical equity using IMIX distribution (Ethernet throughput)"

# Put the label inside the graph
set key on inside top right

# Ploting!
plot "gnuplot.data" using 0:2:xtic(1) with boxes title "FreeBSD 11-head (r287478)" ls 1, \
	 "gnuplot.data" using 0:2:3:4 with yerrorbars lc rgb 'black' pt 1 lw 2 notitle, \
     "../fbsd10.2/gnuplot.data" using 0:2:xtic(1) with boxes title "FreeBSD 10.2" ls 2, \
	 "../fbsd10.2/gnuplot.data" using 0:2:3:4 with yerrorbars lc rgb 'blue' pt 1 lw 2 notitle

