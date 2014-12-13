#!/usr/bin/env bash
ff=$(tempfile)
curl -s shah32768.sdf.org/cgi-bin/rate.cgi?zprtich > /dev/null &&  curl -s shah32768.sdf.org/cgi-bin/rate.cgi?usd > "$ff" 
sync 
gnuplot -e "
reset;
set terminal png size 4096,480;
set xdata time;
set timefmt '%Y/%m/%d %H:%M:%S';
set format x '%Y/%m/%d %H:%M:%S';
set xlabel 'Time';
set xtics rotate by -20;
set xtics 604800;
set ylabel 'Dram/USD';
set title 'USD Exchange Rate';
set key reverse Left outside;
set grid;
set style data linespoints;
plot '$ff' using 2:4 title 'Sell', '' using 2:5 title 'Buy', '' using 2:6 title 'CB'
" | curl -s -X POST shah32768.sdf.org/cgi-bin/rate.cgi?upload-usd-png --upload-file "-" 
rm $ff 

