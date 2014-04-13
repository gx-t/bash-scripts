#!/usr/bin/env bash

ww=`date +%V%y`
mkdir ../reports/${ww}
chmod a+rx ../reports/${ww}
cd ../reports/${ww}
name=`awk '
  function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  function trim(s)  { return rtrim(ltrim(s)); }
  BEGIN {
    FS="="
    fname="/dev/null"
  }
  {
    if($1=="name") {
      name=trim(substr($0,index($0,$2)));
      print(name);
      fname=name".html";
      print("<h4>"name"</h4>") > fname;
      print("<ol>") >> fname;
    }
    else if($1=="ww") {
      print("</ol>\nWW"trim($2)" tasks:\n<ol>") >> fname;
    }
    else {
      if(trim($2)!="" && $1!="ww") print("<li>"trim(substr($0,index($0,$2))"</li>")) >> fname;
    }
  }
  END {
    print("</ol>") >> fname;
  }
'`
cd ..
echo "<!DOCTYPE html>
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>
</head>
<body>
<h3><u>`head -n 1 "users/$name"`</u></h3>" > ${ww}.html
cat ../reports/${ww}/*.html >> ${ww}.html
echo "</body></html>" >> ${ww}.html
printf "Content-type: text/html\nConnection: close\n\n";
echo "<html>
<body>
<h2>Submitted</h2>
<a href=../reports/${ww}.html>See final report</a>
</body>
</html>"

