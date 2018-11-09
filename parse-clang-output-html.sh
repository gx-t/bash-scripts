#!/bin/bash

while read line
do
    [[ "$line" =~ ^.*\<td\ class=\"DESC\"\>(.+)\</td\>\<td\>(.+)\</td\>\<td\ class=\"DESC\"\>(.+)\</td\>\<td\ class=\"Q\"\>(.+)\</td\>\<td\ class=\"Q\"\>(.+)\</td\> ]] && echo "DESCR: ${BASH_REMATCH[1]} FILE: ${BASH_REMATCH[2]} WHAT: ${BASH_REMATCH[3]} LINE: ${BASH_REMATCH[4]} POS: ${BASH_REMATCH[5]}"
done

