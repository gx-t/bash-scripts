#!/usr/bin/env bash
#gats currency rates from ACBA first page
while true
do
wget -q -O- acba.am | egrep -o '<td>[0-9.]+</td>' | egrep -o '[0-9.]+' | { read -d \n -a arr;echo "ACBA $(date) $(date +%s) ${arr[@]}"; } >> ~/data/rate.log
sleep 43200
done

