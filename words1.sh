#!/bin/bash
url=$(zenity --width=800 --title="Բառեր" \
--ok-label="Շարունակել" --cancel-label="Դադարեցնել" \
--entry --text="Հասցեները․" --entry-text="http://")
if (($? != 0)); then exit 1; fi
file=$(zenity --title="Ընտրեք ելքային ֆայլի անունը" --file-selection --save --file-filter="*.html")
if (($? != 0)); then exit 1; fi
wget -O- $url |
tr " \t" "\n" | sort -u |
gawk 'BEGIN {
  c1=0;c2=0;c3=0;
  printf("<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/></head><body><table>\n");
}
function max(n1,n2,n3) {
  res = n1;
  if(n2 > res) res = n2;
  if(n3 > res) res = n3;
  return res;
}
/^[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a1[c1++]=$1;}
/^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a2[c2++]=$1;}
/^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ]$/ {a3[c3++]=$1;}
END {
  n1=asort(a1);
  n2=asort(a2);
  n3=asort(a3);
  cnt = max(n1,n2,n3);
  for(i=1;i<=cnt;i++) {
    printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", a1[i], a2[i], a3[i]);
  }
  printf("</table></body></html>\n");
}' > $file
sensible-browser $file &


