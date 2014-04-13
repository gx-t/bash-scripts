#!/usr/bin/env bash
printf "Content-type: text/html\n"
printf "Connection: close\n\n"

ww=`expr $(date +%V) + 1`
echo "<html>
<head>
<h2>Weekly Report</h2>
</head>
<body>
<form action=/cgi-bin/report-submit.cgi method=post enctype=text/plain>
Name: <input name=name type=text size=32></input><br/>
<ol>"
for ((i=0;i<10;i++));do echo "<li><input name=task type=text size=64></input></li>";done
echo "</ol>
<hr>
<h4>WW$ww</h4>
<input name=ww type=hidden value=$ww></input>
<ol>"
for ((i=0;i<10;i++));do echo "<li><input name=task type=text size=64></input></li>";done
echo "</ol>
<input type=submit value=Submit></input>
</form>
</body>
</html>"

