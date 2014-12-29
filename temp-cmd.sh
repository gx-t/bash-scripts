#!/usr/bin/env bash
ff=$(tempfile)
curl -s http://shah32768.sdf.org/cgi-bin/temp.cgi?raw-gzip | gzip -d |
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
	printf("%s %s/%s/%s %s %s\n", $1, $6, mon[$2], $3, $4, $7);
}' > $ff
sync

gnuplot -e "
reset;
set terminal png size 4096,512;
set xdata time;
set timefmt '%Y/%m/%d %H:%M:%S';
set format x '%Y/%m/%d %H:%M:%S';
set xtics rotate by -20;
set xtics 604800;
set key reverse Left outside;
set grid;
set style data linespoints;
plot '$ff' using 2:4 title 'Degree (C)';
" | curl -s -X POST shah32768.sdf.org/cgi-bin/temp.cgi?upload-png --upload-file "-" 

rm $ff

