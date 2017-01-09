# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png size 1920,1080 font "Gill Sans,22"
#set terminal png size 3840,2160 font "Gill Sans,44"
set output 'graph.png'
#set terminal svg size 1920,1080 font "Gill Sans,22" rounded dashed
#set output 'graph.svg'
#set terminal pdf size 10,6 color font "Gill Sans,16" rounded dashed enhanced
#set output 'graph.pdf'

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

set xtics rotate
# Draw a corresponding IMIX Eth throughput estimation on the right side
set y2tics
# IMIX: packet * ( 7*(40+14) + 4*(576+14) + (1500+14))/12*8 = 2834.666667
set link y2 via y * 2834.666667 inverse y/2834.666667
# Replace long value by M (million), K (kilo) on ytics
set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s' 

# Only integer value for xtics
set xtics 1

set title "One year (2016) of pf/ipfw's impact on forwarding performance\n Platform: Netgate RCC-VE 4860, 4 cores Intel Atom C2558E"
set xlabel "FreeBSD head svn revision number \n Note:GENERIC-NODEBUG kernel, harvest.mask=351, 2 firewall statefull rules"
set ylabel "Packets per second (minimum size, 2000 flows)\n minimum,median,maximum values of 5 benchs"
set y2label "Theorical equity using simple IMIX distribution\n (Ethernet throughput)"

# Put the label inside the graph
set key on inside bottom right

# Specific labels
set arrow 1 from 300000,680000 to 303643,744492
set label 1 "r303643 \"Implement trivial backoff for locking primitives\"(mjg@)" at 294000,650000 left noenhanced

set arrow 2 from 304000,920000 to 309257,952398
set label 2 "r309257 \"Rework ip_tryforward() to use FIB4 KPI\"(ae@)" at 300000,900000 left noenhanced

# Ploting!

plot "forwarding.data" using 1:2:xtic(1) title 'forwarding' with linespoints ls 2, \
     "" using 1:2:3:4 with yerrorbars ls 1 notitle, \
	 "ipfw.data" using 1:2:xtic(1) title 'ipfw' with linespoints ls 3, \
     "" using 1:2:3:4 with yerrorbars ls 1 notitle, \
	 "pf.data" using 1:2:xtic(1) title 'pf' with linespoints ls 1, \
     "" using 1:2:3:4 with yerrorbars ls 1 notitle,