#!/usr/bin/env bash
tbl_name='voters2021'

check-reqs() {
    wget --version && libreoffice --version && sqlite3 --version
}

download-xlsxs() {
    wget -t 0 -c -k -np -r http://www.police.am/Cucakner/cucakner
}

convert-xlsx-to-csv() {
    mkdir -p csv
    libreoffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 --outdir csv ./*.xlsx
}
#ԱԶԳԱՆՈՒՆ,ԱՆՈՒՆ,ՀԱՅՐԱՆՈՒՆ,"ԾՆՆԴՅԱՆ ՕՐ, ԱՄԻՍ, ՏԱՐԻ",ՄԱՐԶ,ՀԱՄԱՅՆՔ,ԲՆԱԿԱՎԱՅՐ,ՀԱՍՑԵ,ՏԱՐԱԾՔ,ՏԵՂԱՄԱՍ,ՆՇՈՒՄ

convert-csvs-to-sqlite() {
    echo "drop table if exists $tbl_name;"
    echo "create table $tbl_name (lname text, name text, fname text, birthdate text, region text, town text, village text, address text, area text, section text, note text);"

    echo ".mode csv"
    echo "begin transaction;" 
    for ff in csv/*.csv
    do
        echo ".import $ff $tbl_name"
    done
    echo "end transaction;" 
    
    echo "delete from $tbl_name where lname='ԱԶԳԱՆՈՒՆ' and name='ԱՆՈՒՆ' and fname='ՀԱՅՐԱՆՈՒՆ';"
    echo "vacuum;"
}

#check-reqs && download-xlsxs && cd www.police.am/Cucakner/cucakner && convert-xlsx-to-csv && cd csv && convert-csvs-to-sqlite | sqlite3 -csv elections.db

print-unique-name-freq() {
    printf ".mode csv\n.header on\n.width 32\nselect name, count(name) from $tbl_name group by name order by count(*);\n"
}

find-name() {
    printf ".mode column\nselect *, count(name) from $tbl_name where name=\""$1\"" group by name;\n"
}

