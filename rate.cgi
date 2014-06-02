#!/usr/bin/env bash
printf "Content-type: text/plain\n"
printf "Connection: close\n\n"

if [ $1 == $(cat rate-key) ]
then
  wget -q -O- acba.am | egrep -o '<td>[0-9.]+</td>' | egrep -o '[0-9.]+' | { read -d \n -a arr;echo "ACBA $(date) $(date +%s) ${arr[@]}"; } >> ~/data/rate.log
  echo OK
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

