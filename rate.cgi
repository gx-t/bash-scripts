#!/usr/bin/env bash
printf "Content-type: text/plain\n"
printf "Connection: close\n\n"

if [ $1 == $(cat rate-key) ]
then
  wget -q -t 0 -O- acba.am | egrep -o '<td>[0-9.]+</td>' | egrep -o '[0-9.]+' | { read -d \n -a arr;[ ${#arr[@]} -gt 0 ] && echo "ACBA $(TZ=Asia/Yerevan date) $(TZ=Asia/Yerevan date +%s) ${arr[@]}"; } >> ~/data/rate.log
  echo OK
  exit 0
fi

if [ $1 == "raw" ]
then
  cat ~/data/rate.log
  exit 0
fi

if [[ $1 == "usd" ]]
then
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
  }'
  exit 0
fi

if [[ $1 == "usd-euro-lari-rur" ]]
then
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
    if(a != $9 || b != $10 || c = $11 || d != $12 || e != $13 || f != $14 || g != $24 || h != $25 || i != $26 || j != $15 || k != $16 || l != $17) {
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
  }'
  exit 0
fi

if [ $1 == "upload-usd-png" ]
then
  cat > ~/html/img/usd.png
  exit 0
fi

if [ $1 == "upload-euro-png" ]
then
  cat > ~/html/img/euro.png
  exit 0
fi

date
echo "===================================="
echo "USD             ACBA    ACBA   CBA"
echo "===================================="
cat ~/data/rate.log | awk '{printf("%s %s %s: %8s%8s%8s \n", $2, $3, $4, $9, $10, $11)}'
echo "===================================="
echo "EURO            ACBA    ACBA   CBA"
echo "===================================="
cat ~/data/rate.log | awk '{printf("%s %s %s: %8s%8s%8s \n", $2, $3, $4, $12, $13, $14)}'
