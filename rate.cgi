#!/usr/bin/env bash

hd1="Content-type: text/plain; charset=us-ascii
Connection: close
"

hd2="Content-type: application/gzip; charset=binary
Connection: close
"


if [ $1 == $(cat rate-key) ]
then
  wget -q -t 0 -O- acba.am | egrep -o '<td>[0-9.]+</td>' | egrep -o '[0-9.]+' | { read -d \n -a arr;[ ${#arr[@]} -gt 0 ] && echo "ACBA $(TZ=Asia/Yerevan date) $(TZ=Asia/Yerevan date +%s) ${arr[@]}"; } >> ~/data/rate.log
  echo "$hd1"
  echo OK
  exit 0
fi

[[ $1 == "raw" ]] && echo "$hd1" && cat ~/data/rate.log && exit 0

[[ $1 == "raw-gzip" ]] && echo "$hd2" && gzip -9 -c ~/data/rate.log && exit 0 

[[ $1 == "usd" ]] &&
  echo "$hd1" &&
  cat ~/data/rate.log |
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
    a = 0;
    b = 0;
    c = 0;
  } {
    if(a != $9 || b != $10 || c != $11) {
      printf("%s %s/%s/%s %s %s %s %s\n", $2, $7, mon[$3], $4, $5, $9, $10, $11);
      a = $9;
      b = $10;
      c = $11;
    }
  }' && exit 0

[[ $1 == "usd-gzip" ]] &&
  echo "$hd2" &&
  cat ~/data/rate.log |
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
    a = 0;
    b = 0;
    c = 0;
  } {
    if(a != $9 || b != $10 || c != $11) {
      printf("%s %s/%s/%s %s %s %s %s\n", $2, $7, mon[$3], $4, $5, $9, $10, $11);
      a = $9;
      b = $10;
      c = $11;
    }
  }' | gzip -9 && exit 0

[[ $1 == "usd-euro-lari-rur" ]] &&
  echo "$hd1" &&
  cat ~/data/rate.log |
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
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    e = 0;
    f = 0;
    h = 0;
    i = 0;
    j = 0;
    k = 0;
    l = 0;
  } {
    if(a != $9 || b != $10 || c != $11 || d != $12 || e != $13 || f != $14 || g != $24 || h != $25 || i != $26 || j != $15 || k != $16 || l != $17) {
      printf("%s %s/%s/%s %s %s %s %s %s %s %s %s %s %s %s %s %s\n", $2, $7, mon[$3], $4, $5, $9, $10, $11, $12, $13, $14, $24, $25, $26, $15, $16, $17);
      a = $9;
      b = $10;
      c = $11;
      d = $12;
      e = $13;
      f = $14;
      g = $24;
      h = $25;
      i = $26;
      j = $15;
      k = $16;
      l = $17;
    }
  }' && exit 0

[[ $1 == "usd-euro-lari-rur-gzip" ]] &&
  echo "$hd2" &&
  cat ~/data/rate.log |
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
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    e = 0;
    f = 0;
    h = 0;
    i = 0;
    j = 0;
    k = 0;
    l = 0;
  } {
    if(a != $9 || b != $10 || c != $11 || d != $12 || e != $13 || f != $14 || g != $24 || h != $25 || i != $26 || j != $15 || k != $16 || l != $17) {
      printf("%s %s/%s/%s %s %s %s %s %s %s %s %s %s %s %s %s %s\n", $2, $7, mon[$3], $4, $5, $9, $10, $11, $12, $13, $14, $24, $25, $26, $15, $16, $17);
      a = $9;
      b = $10;
      c = $11;
      d = $12;
      e = $13;
      f = $14;
      g = $24;
      h = $25;
      i = $26;
      j = $15;
      k = $16;
      l = $17;
    }
  }' | gzip -9 && exit 0

[[ $1 == "upload-usd-png" ]] && echo "$hd1" && cat > ~/html/img/usd.png && exit 0

[[ $1 == "upload-euro-png" ]] && echo "$hd1" && cat > ~/html/img/euro.png && exit 0

echo "$hd1" &&
date
echo "===================================="
echo "USD             ACBA    ACBA   CBA"
echo "===================================="
cat ~/data/rate.log | awk '{printf("%s %s %s: %8s%8s%8s \n", $2, $3, $4, $9, $10, $11)}'
echo "===================================="
echo "EURO            ACBA    ACBA   CBA"
echo "===================================="
cat ~/data/rate.log | awk '{printf("%s %s %s: %8s%8s%8s \n", $2, $3, $4, $12, $13, $14)}'
