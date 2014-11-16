#!/bin/bash
ff=/tmp/$$.dat
awk '
  BEGIN {
  mon["Jan"]="01";
  mon["Feb"]="02";
  mon["Mar"]="03";
  mon["Apr"]="04";
  mon["May"]="05";
  mon["Jun"]="06";
  mon["Jul"]="07";
  mon["Aug"]="08";
  mon["Sep"]="09";
  mon["Oct"]="10";
  mon["Nov"]="11";
  mon["Dec"]="12";
} {
  printf("%s %s/%s/%s %s %s %s %s\n", $2, $7, mon[$3], $4, $5, $9, $10, $11);
}' > "$ff"
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
set yrange [404:419];
set title 'USD Exchange Rate';
set key reverse Left outside;
set grid;
set style data linespoints;
plot '$ff' using 2:4 title 'Sell', '' using 2:5 title 'Buy', '' using 2:6 title 'CB'
"
rm "$ff"

