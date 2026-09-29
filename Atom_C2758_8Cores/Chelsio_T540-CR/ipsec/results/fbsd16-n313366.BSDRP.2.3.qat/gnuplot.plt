# Gnuplot script file for plotting data from bench lab

## Using pretty style from http://youinfinitesnake.blogspot.fr/2011/02/attractive-scientific-plots-with.html

# scale axes automatically, but force to start at 0 for y
set yrange [0:*]

# output
set terminal png truecolor size 1920,1080 font "Gill Sans,22"
set output 'graph.png'

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

# Line styles: green for the AES-NI arm, matching the IPv4 series of the
# sibling cypher bench; red for QAT, which is the regression here.
set style line 1 lt 1
set style line 2 lt 1
set style line 2 lt rgb "#00A000" lw 2 pt 9
set style line 1 lt rgb "#A00000" lw 2 pt 7

# Fill box and width
set style fill solid 1.0 border -1
set style histogram errorbars gap 2 lw 2
set boxwidth 0.9 relative
set ytics 250
set ytics format '%.0f'

# Only integer value for xtics
set xtics 1
set xtics rotate by -18 offset 0,-0.7
set xtics font ", 17"

set title noenhanced "Intel QuickAssist (QAT) versus AES-NI on IPsec VTI (route-based), IPv4 and IPv6\nSuperMicro 5018A-FTN4 (8 cores Atom C2758) and 10G Chelsio T540-CR"
set xlabel noenhanced "FreeBSD 16-CURRENT n313366 (BSDRP 2.3), 2000 flows in both families\n500 Bytes UDP payload (542B frame in IPv4, 562B in IPv6)\nQAT = qat_c2xxx0 loaded from rc.conf, one acceleration engine (the C2000 fuses off the second)\nMethodology for Benchmarking IPsec Gateways:\nhttp://www.mecs-press.org/ijcnis/ijcnis-v4-n9/IJCNIS-V4-N9-1.pdf"
set ylabel noenhanced "Equilibrium Ethernet throughput in Mb/s\n minimum,median,maximum values of 5 benches"

# Put the label inside the graph
set key on inside top right

# Ploting!
plot "inet4.aesni.data" using 2:3:4:xticlabels(1) with histogram title "AES-NI IPv4" ls 2, \
     "inet6.aesni.data" using 2:3:4 with histogram title "AES-NI IPv6" ls 3, \
     "inet4.qat.data"   using 2:3:4 with histogram title "QAT IPv4" ls 1, \
     "inet6.qat.data"   using 2:3:4 with histogram title "QAT IPv6" ls 4
