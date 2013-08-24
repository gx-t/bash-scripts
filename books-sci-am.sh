#!/bin/bash
#sleep $(expr $(date -d "02:00" +%s) - $(date +%s))
mkdir books
cd books
base=http://serials.flib.sci.am/openreader/
list_url=http://serials.flib.sci.am/openreader/test/index.html
book_lst=$(wget -qO- ${list_url} | egrep -o  "href=\"\.\..*" | awk  'BEGIN {FS="/"};{print $2}' | sort -u)
for book in ${book_lst}
do
  echo "processing: ${book}"
  mkdir ${book}
  cd ${book}
  page=1
  page_fmt=$(printf "%.3d" ${page})
  url=${base}${book}/book/${page_fmt}.jpg
  out="${page_fmt}.jpg"
  while wget -c ${url} -O ${out}
  do
#    if [ $(date +%s) -gt  $(date -d "08:00" +%s) ]; then  sleep inf; fi
    page=$(expr ${page} + 1)
    page_fmt=$(printf "%.3d" ${page})
    url=${base}${book}/book/${page_fmt}.jpg
    out="${page_fmt}.jpg"
  done
  cd ..
done
cd ..
