# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png truecolor size 1920,1080 font "Gill Sans,22"
set output 'VPNs-Atom_C2758.png'
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
# Replace long value by M (million), K (kilo) on ytics
set mytics 2

# Only integer value for xtics
set xtics font ", 20"

set title noenhanced "Impact of cyphers on VPN throughput\nSuperMicro SuperServer 5018A-FTN4 (8 cores Atom C2758 and Chelsio T540-CR)"
set xlabel noenhanced "FreeBSD 13 r365415 with D26137, 5000 clear flows to encrypt, 500 Bytes UDP payload\nMethodology for Benchmarking IPsec Gateways:\nhttp://www.mecs-press.org/ijcnis/ijcnis-v4-n9/IJCNIS-V4-N9-1.pdf" offset 0,-1,0
set ylabel "Equilibrium Ethernet throughput in Gb/s\n minimum,median,maximum values of 5 benches"

# Put the label inside the graph
set key on inside top right

set label "Warning: Strange low OpenVPN and high WireGuard results under investigation" center\
    at screen 0.5,0.6 tc rgb"#cccccc"

# Ploting!
plot "VPNs-Atom_C2758.data" using 2:3:4:xticlabels(1) with histogram notitle ls 2,\
 ''using 0:($2+0.25):2 with labels notitle
