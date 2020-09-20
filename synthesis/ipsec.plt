# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png truecolor size 1920,1080 font "Gill Sans,22"
set output 'ipsec.png'
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
#set ytics format '%.0s%c'

# Only integer value for xtics
set xtics 1
#set xtics rotate
set xtics font ", 20"

set title noenhanced "Impact of cyphers on IPSec VTI throughput"
set xlabel "FreeBSD r365873, 500 Bytes UDP payload\nMethodology for Benchmarking IPsec Gateways:\nhttp://www.mecs-press.org/ijcnis/ijcnis-v4-n9/IJCNIS-V4-N9-1.pdf"
set ylabel "Equilibrium Ethernet throughput in Mb/s\n minimum,median,maximum values of 5 benches"

# Put the label inside the graph
set key on vert top left font ",18"

# Ploting!
plot "../AMD_GX-412TC_4Cores-Intel_i210AT/ipsec/results/fbsd13-r365873.vti/gnuplot.data" using 2:3:4:xticlabels(1) with histogram title "PC Engines APU2C4(4 cores GX-412TC at 1GHz)" ls 1, \
     ''using ($0-0.25):( $2 + 80 ):2 with labels notitle, \
	 "../Atom_C2558_4Cores-Intel_i350/ipsec/results/fbsd13-r365873.vti/gnuplot.data" using 2:3:4:xticlabels(1) with histogram title "Netgate RCC-VE 4860(4 cores Atom C2558E at 2.4GHz)" ls 4, \
     ''using ($0-0.08):( $2 + 80 ):2 with labels notitle, \
     "../Atom_C2758_8Cores-Chelsio_T540-CR/ipsec/results/fbsd13-r365873.vti/gnuplot.data" using 2:3:4:xticlabels(1) with histogram title "SuperMicro SuperServer 5018A-FTN4(8 cores Atom C2758 at 2.4GHz)" ls 3, \
     ''using ($0+0.07):( $2 + 80 ):2 with labels notitle, \
     "../Xeon_E5-2650_8Cores-Chelsio_T540-CR/ipsec/results/fbsd13-r365873.vti/gnuplot.data" using 2:3:4:xticlabels(1) with histogram title "HP ProLiant DL360p Gen8(8 cores Xeon E5-2650 at 2.6GHz)" ls 2, \
     ''using ($0+0.25):( $2 + 80 ):2 with labels notitle
