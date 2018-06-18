# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png transparent truecolor size 1920,1080 font "Gill Sans,22"
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
set style line 5 lt 1
set style line 1 lt rgb "#A00000" lw 3 pt 7
set style line 2 lt rgb "#00A000" lw 3 pt 9
set style line 3 lt rgb "#5060D0" lw 3 pt 5
set style line 4 lt rgb "#F25900" lw 3 pt 13
set style line 5 lt rgb "gold" lw 3 pt 13

# Fill box and width
set style fill solid
set boxwidth 0.8
# Draw a corresponding IMIX Eth throughput estimation on the right side
set y2tics
# IMIX: packet * ( 7*(40+14) + 4*(576+14) + (1500+14))/12*8 = 2834.666667
set link y2 via y * 2834.666667 inverse y/2834.666667
# Replace long value by M (million), K (kilo) on ytics
set ytics format '%.1s%c'
#set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s' 


# Only integer value for xtics
set xtics 1
set grid mxtics
set grid mytics
set mxtics 2
set mytics 2

set title noenhanced "Number of NIC's queues vs forwarding performance\nDell PowerEdge R630 with 2 Intel E5-2650 v4 2.2Ghz (2x12 cores)"
set xlabel noenhanced "Number of queues (Chelsio T520-CR NIC)\n(HyperThreading and LRO/TSO disabled, harvest.mask=351"
set ylabel "Packets per second (minimum size, 5000 flows)\n minimum,median,maximum values of 5 benchs"
set y2label "Theorical equity using simple IMIX distribution (Ethernet throughput)"

# Put the label inside the graph
#set key on inside bottom right
set key at 20,5000000

f(x) = x<=9 ? 1567228 * ( x + 1 )  : 1/0
e(x) = 14880960

Theads = 'heads size 0.5,90 front ls 201 lw 10'
set arrow from 0,000000 to 11.3,000000 @Theads
set arrow from 11.7,000000 to 23,000000 @Theads
set label "local NUMA domain" at 3,500000 font ",25"
set label "remote NUMA domain" at 14,500000 font ",25"

# Ploting!
plot e(x) with lines title "10 Gigabit line-rate" ls 5 lw 5 ps 4, \
	f(x) with lines title "linear reference" linestyle 3, \
	 "gnuplot.data" using 0:2:xtic(1) with lines title "FreeBSD 12 head r335286" ls 2, \
	 "gnuplot.data" using 0:2:3:4 with yerrorbars lc rgb 'black' pt 1 lw 2 notitle
	# "Dell-mlx5en.data" using 0:2:xtic(1) with lines title "Mellanox ConnectX-4 Lx NIC" ls 4, \
	 #"Dell-mlx5en.data" using 0:2:3:4 with yerrorbars lc rgb 'black' pt 1 lw 2 notitle, \
	  #"Dell-ixgbe.data" using 0:2:xtic(1) with lines title "Intel 82599ES NIC" ls 1, \
	# "Dell-ixgbe.data" using 0:2:3:4 with yerrorbars lc rgb 'black' pt 1 lw 2 notitle