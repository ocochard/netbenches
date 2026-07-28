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

set grid back linestyle 81

# Remove border on top and right.
set border 3 back linestyle 80
set tics nomirror

set style line 1 lt 1
set style line 2 lt 1
set style line 1 lt rgb "#A00000" lw 2 pt 7
set style line 2 lt rgb "#00A000" lw 2 pt 9

set style fill solid 1.0 border -1
set style histogram errorbars gap 2 lw 2
set boxwidth 0.9 relative

# Draw a corresponding IMIX Eth throughput estimation on the right side
set y2tics
set link y2 via y * 2834.666667 inverse y/2834.666667
set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s'

set title noenhanced "Impact of D58513 (e1000 UDP RSS hash type) on FreeBSD 16-CURRENT (n311215) UDP forwarding\nPC Engines APU2 (4 cores AMD GX-412TC with Intel i210AT)"
set xlabel "Note: fastforwarding, ICMP redirect disabled, 2000 UDP flows, minimum frame size (inet4)"
set ylabel "Packets per second (minimum size, 2000 flows)\n minimum,median,maximum values of 5 benchs"
set y2label "Theorical equity using simple IMIX distribution (Ethernet throughput)"

set key on inside top left

plot "prepatch.data"  using 2:3:4:xticlabels(1) with histogram title "pre-patch (single TX queue)" ls 1, \
     "postpatch.data" using 2:3:4:xticlabels(1) with histogram title "post-patch D58513 (4 TX queues)" ls 2
