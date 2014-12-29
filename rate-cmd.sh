#!/usr/bin/env bash
ff=$(tempfile)
curl -s shah32768.sdf.org/cgi-bin/rate.cgi?zprtich > /dev/null &&  curl -s shah32768.sdf.org/cgi-bin/rate.cgi?usd-euro-lari-rur-gzip | gzip -d > "$ff" 
sync 
gnuplot -e "
reset;
set terminal png size 4096,2048;
set xdata time;
set timefmt '%Y/%m/%d %H:%M:%S';
set format x '%Y/%m/%d %H:%M:%S';
set xtics rotate by -20;
set xtics 604800;
set key reverse Left outside;
set grid;
set style data linespoints;
set multiplot layout 4, 1;
plot '$ff' using 2:4 title 'USD->Dram', '' using 2:5 title 'Dram->USD', '' using 2:6 title 'CB';
plot '$ff' using 2:7 title 'Euro->Dram', '' using 2:8 title 'Dram->Euro', '' using 2:9 title 'CB';
plot '$ff' using 2:10 title 'Lari->Dram', '' using 2:11 title 'Dram->Lari', '' using 2:12 title 'CB';
plot '$ff' using 2:13 title 'RUR->Dram', '' using 2:14 title 'Dram->RUR', '' using 2:15 title 'CB';
unset multiplot;
" | curl -s -X POST shah32768.sdf.org/cgi-bin/rate.cgi?upload-usd-png --upload-file "-" 
rm "$ff" 

