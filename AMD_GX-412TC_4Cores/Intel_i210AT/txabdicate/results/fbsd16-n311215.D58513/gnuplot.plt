# Gnuplot script file for plotting data from bench lab

set yrange [0:*]
set terminal png truecolor size 1920,1080 font "Gill Sans,22"
set output 'graph.png'

set style line 80 lt 0
set style line 80 lt rgb "#808080"
set style line 81 lt 3
set style line 81 lt rgb "#808080" lw 0.5
set grid back linestyle 81
set border 3 back linestyle 80
set tics nomirror

set style line 1 lt rgb "#A00000" lw 2 pt 7
set style line 2 lt rgb "#00A000" lw 2 pt 9

set style fill solid 1.0 border -1
set style histogram errorbars gap 2 lw 2
set boxwidth 0.9 relative

set y2tics
set link y2 via y * 2834.666667 inverse y/2834.666667
set ytics format '%.1s%c'
set y2tics format '%.1s%cb/s'

set title noenhanced "Impact of D58513 (e1000 UDP RSS hash type) on FreeBSD 16-CURRENT (n311215) UDP forwarding with iflib tx_abdicate\nPC Engines APU2 (4 cores AMD GX-412TC with Intel i210AT)"
set xlabel "Note: fastforwarding, ICMP redirect disabled, 2000 UDP flows, minimum frame size"
set ylabel "Packets per second (minimum size, 2000 flows)\n minimum,median,maximum values of 5 benchs"
set y2label "Theorical equity using simple IMIX distribution (Ethernet throughput)"

set xtics rotate by -20
set key on inside top left

plot "prepatch.data"  using 2:3:4:xticlabels(1) with histogram title "pre-patch (single TX queue)" ls 1, \
     "postpatch.data" using 2:3:4:xticlabels(1) with histogram title "post-patch D58513 (4 TX queues)" ls 2
