#!/usr/bin/env bash
ff=$(tempfile)
curl -s shah32768.sdf.org/cgi-bin/rate.cgi?zprtich > /dev/null &&  curl -s shah32768.sdf.org/cgi-bin/rate.cgi?usd-euro-lari-rur > "$ff" 
sync 
gnuplot -e "
reset;
set terminal png size 4096,2048;
set xdata time;
set timefmt '%Y/%m/%d %H:%M:%S';
set format x '%Y/%m/%d %H:%M:%S';
set xlabel 'Time';
set xtics rotate by -20;
set xtics 604800;
set key reverse Left outside;
set grid;
set style data linespoints;
set multiplot layout 4, 1;
set title 'USD Exchange Rate';
set ylabel 'Dram/USD';
plot '$ff' using 2:4 title 'Sell', '' using 2:5 title 'Buy', '' using 2:6 title 'CB';
set title 'Euro Exchange Rate';
set ylabel 'Dram/Euro';
plot '$ff' using 2:7 title 'Sell', '' using 2:8 title 'Buy', '' using 2:9 title 'CB';
set title 'Lari Exchange Rate';
set ylabel 'Dram/Lari';
plot '$ff' using 2:10 title 'Sell', '' using 2:11 title 'Buy', '' using 2:12 title 'CB';
set title 'RUR Exchange Rate';
set ylabel 'Dram/RUR';
plot '$ff' using 2:13 title 'Sell', '' using 2:14 title 'Buy', '' using 2:15 title 'CB';
unset multiplot;
" | curl -s -X POST shah32768.sdf.org/cgi-bin/rate.cgi?upload-usd-png --upload-file "-" 
rm "$ff" 

