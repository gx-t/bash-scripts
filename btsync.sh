#!/bin/bash

bs-start() {
  (($# == 1)) && sleep $(time_to $1)
  echo $(date)
  ~/btsync/btsync --config ~/btsync/.conf
}

bs-stop() {
  pid_file=~/btsync/.sync/sync.pid
  if [ -f $pid_file ]
  then
    pid=$(head -n1 $pid_file)
    kill $pid
    echo $(date)
    echo "killed $pid"
    rm $pid_file
  fi
}

time_to() {
  dt=$(expr $(date -d $1 +%s) - $(date +%s))
  echo "if($dt<0) $dt+(24*3600) else $dt" | bc
}

bs-night() {
  echo $(date)
  echo "Waiting for night time to start btsync..."
  sleep $(time_to "02:00")
  bs-start
  echo "Waiting for morning to kill btsync..."
  sleep $(time_to "08:00")
  bs-stop
}

get-rates() {
  wget -t 0 -q shah32768.sdf.org/cgi-bin/rate.cgi?zprtich -O-
}

tr-night() {
  echo $(date)
  echo "Waiting for night time to start transmission-gtk..."
  sleep $(time_to "02:00")
  transmission-gtk &
#  get-rates
  echo "Waiting for morning to kill transmission-gtk..."
  sleep $(time_to "08:00")
  killall transmission-gtk
}

3g-monitor() {
  while /home/shah/proj/c-projs/3g-zte-tool/3g-zte-tool network-status
  do
    sleep 1
  done
}

file-text-subst () {
  find . -name $1 -exec sed -i 's,'"$2"','"$3"',' {} \;
}

_radio-goto-dir() {
  xx=~/Downloads/radio/$(date)
  mkdir -p "$xx"
  cd "$xx"
}

radio-download-pirate-radio() {
  pushd .
  _radio-goto-dir
  streamripper http://174.127.65.10:80 -q -a radio
  popd
}

radio-download-polskastancia() {
  pushd .
  _radio-goto-dir
#  streamripper http://91.121.249.18:80 -a radio
  streamripper http://91.121.103.183:6200 -q
  popd
}

radio-download-metal-only() {
  pushd .
  _radio-goto-dir
  streamripper http://80.237.225.70:9480 -q -a radio
  popd
}

#get-words։ քաշում է $1 հասցեից $2 սկսվող բառերի ցուցակը
get-words () {
  echo "[$2]"
  wget -O- $1 | grep -w -o "\<[$2][ա-ֆԱ-Ֆ՞՜]\+" | sort -u
}

ff() {
  wget -O- $1 |
  tr " \t" "\n" | sort -u |
  gawk 'BEGIN {
    c1=0;c2=0;c3=0;
    printf("<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/></head><body><table>\n");
  }
  function max(n1,n2,n3) {
    local res = n1;
    if(n2 > res) res = n2;
    if(n3 > res) res = n3;
    return res;
  }
  /^[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a1[c1++]=$1;}
  /^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a2[c2++]=$1;}
  /^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ]$/ {a3[c3++]=$1;}
  END {
    local n1=asort(a1);
    local n2=asort(a2);
    local n3=asort(a3);
    local cnt = max(n1,n2,n3);
    for(i=1;i<=cnt;i++) {
      printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", a1[i], a2[i], a3[i]);
    }
    printf("</table></body></html>\n");
  }'
}

bat-cap() {
  cap=$(printf "scale=4\n100 * %d / %d\n" \
  $(cat /sys/class/power_supply/BAT0/charge_full) \
  $(cat /sys/class/power_supply/BAT0/charge_full_design) | bc)
  echo "Full charge:  $cap %"
  cap=$(printf "scale=4\n100 * %d / %d\n" \
  $(cat /sys/class/power_supply/BAT0/charge_now) \
  $(cat /sys/class/power_supply/BAT0/charge_full) | bc)
  echo "Curr charge:  $cap %"
  vol=$(printf "scale=4\n%d / 1000000\n" \
  $(cat /sys/class/power_supply/BAT0/voltage_now) | bc)
  echo "Curr Voltage: $vol V"
}

bat-info() {
  echo "capacity:           $(cat /sys/class/power_supply/BAT0/capacity)"
  echo "charge_full:        $(cat /sys/class/power_supply/BAT0/charge_full)"
  echo "charge_full_design: $(cat /sys/class/power_supply/BAT0/charge_full_design)"
  echo "charge_now:         $(cat /sys/class/power_supply/BAT0/charge_now)"
  echo "current_now:        $(cat /sys/class/power_supply/BAT0/current_now)"
  echo "status:             $(cat /sys/class/power_supply/BAT0/status)"
  echo "voltage_min_design: $(cat /sys/class/power_supply/BAT0/voltage_min_design)"
  echo "voltage_now:        $(cat /sys/class/power_supply/BAT0/voltage_now)"
}

convert-ocr() {
	(($# != 2)) && echo "Usage: $FUNCNAME <infile> <outfile>" && return
	echo "processing $1 ..."
	convert "$1" -verbose -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 "$2"
}

convert-add-label() {
	(($# != 3)) && echo "Usage: $FUNCNAME infile outfile text" && return 1
	convert "$1" \
		-auto-level \
		-gravity south \
		-font /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf \
		-pointsize $(identify -format "%[fx:h/34]" "$1") \
		-stroke '#000C' -strokewidth 2 -annotate 0 "$3" \
		-stroke none -fill red -annotate 0 "$text" \
		"$2"
}

vu-download() {
  local resp
# url, start, minutes, output
  sleep $(time_to "$2")
  rm -f "$4"
#  avconv -i "$1" -vcodec copy -acodec copy -t "$3" "$4"
  resp=$(wget -b -t 0 -c "$1" -O "$4")
  echo "$resp"
  resp=${resp##*pid}
  resp=${resp%%.*}
  echo "Downloading $3 minutes..."
  sleep $(expr 60 \* $3)
  kill -SIGINT $resp
}

transfer() {
  avconv -i "$1" -f matroska -s 1280x720 - | curl -v --upload-file - "https://transfer.sh/$2" >> /tmp/addr.txt
}

camera-jpegs-to-mkv() {
  local src=/media/shah/disk/DCIM/*/*.JPG
  local out="$(date).mkv"
  local size="1600x1200"
  local tmpdir=$(mktemp)
  rm $tmpdir
  mkdir $tmpdir || return
  i=0
  echo "Creating input files links..."
  ls $src | while read ff; do ln -sf "$ff" "$tmpdir/$(printf '%08d.jpeg' $i)"; (( i ++ )); done
  echo "Converting to movie..."
  avconv -i "$tmpdir/%08d.jpeg" -s "$size" "$out"
  rm -rf "$tmpdir"
}

camera-mp4-to-single-mkv() {
  local src=/media/shah/disk/DCIM/*/*.MP4
  local size="1280x720"
#  ls -tr $src | while read ff; do avconv -i "$ff" -s "$size" -vcodec rawvideo -f avi -; done | avconv -i - "$(date).mkv"
  ls -tr $src | while read ff; do avconv -i "$ff" -vcodec rawvideo -r 120 -f avi -; done | avconv -i - "$(date).mkv"
}

vu-download-recorded-to-flash() {
	local dest=/media/shah/VERBATIM
	local vuurl=http://192.168.0.103
	local line
	cd $dest &&
	curl -s "$vuurl/web/movielist" | while read line
	do
		[[ "$line" =~ ^\<e2servicereference\>1:0:0:0:0:0:0:0:0:0:(.+)\<\/e2servicereference\>$ ]] &&
		(wget -t 0 -c "$vuurl/file?file=${BASH_REMATCH[1]}" -O - | avconv -y -i - -s 1280x720 "${BASH_REMATCH[1]:11:-3}.mkv" || return)
	done
}

vu-get-epg-all() {
	local vuurl=http://192.168.0.103
	local line
	local title
	local descr
	local id
	local sref
	local time
	local svcname
	local length
	dbfile="/tmp/vu-epg.db"
	rm -f "$dbfile"
	(echo "create table epgall (id INTEGER PRIMARY KEY,svcname TEXT, title TEXT, descr TEXT, length TEXT, time TIMESTAMP, sref TEXT);
begin transaction;"
	curl -s "$vuurl/web/getallservices" |  while read line
	do
		[[ "$line" =~ ^\<e2servicereference\>(.+)\<\/e2servicereference\>$ ]] &&
		curl -s "$vuurl/web/epgservice?sRef=${BASH_REMATCH[1]}" | tr \" \' | while read line
		do
			[[ "$line" == \<e2event\> ]] && title="" && descr="" && id="" && sref="" && date="" && svcname="" && length=0 && continue
			[[ "$line" =~ ^\<e2eventtitle\>(.+)\<\/e2eventtitle\>$ ]] && title="${BASH_REMATCH[1]}" && continue
			[[ "$line" =~ ^\<e2eventservicename\>(.+)\<\/e2eventservicename\>$ ]] && svcname="${BASH_REMATCH[1]}" && continue
			[[ "$line" =~ ^\<e2eventdescription\>(.+)\<\/e2eventdescription\>$ ]] && descr="${BASH_REMATCH[1]}" && continue
			[[ "$line" =~ ^\<e2eventstart\>(.+)\<\/e2eventstart\>$ ]] && time=$(date -d "@${BASH_REMATCH[1]}" +%Y-%m-%d\ %H:%M:%S) && continue
			[[ "$line" =~ ^\<e2eventduration\>(.+)\<\/e2eventduration\>$ ]] && length="${BASH_REMATCH[1]}" && continue

			[[ "$line" =~ ^\<e2eventid\>(.+)\<\/e2eventid\>$ ]] && id="${BASH_REMATCH[1]}" && continue
			[[ "$line" =~ ^\<e2eventservicereference\>(.+)\<\/e2eventservicereference\>$ ]] && sref="${BASH_REMATCH[1]}" && continue
			[[ "$line" == \<\/e2event\> ]] && echo "insert into epgall (svcname,title,descr,length,time,sref) values (\"$svcname\",\"$title\",\"$descr\",\"$length\",\"$time\",\"$sref\");" && continue
		done
	done; echo "end transaction;") | sqlite3 "$dbfile"
}

vu-movie-list-upload() {
	cmdurl="http://192.168.0.103/web/movielist"
	( echo "<!DOCTYPE html>
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
<title>Պահպանված հաղորդումները</title>
<style>
table, th, td {
	border: 1px solid blue;
}
</style>
</head>
<body>
<h2>Պահպանված հաղորդումների ցանկը ($(date))</h2>
<table>
<tr>
<td><b>Ալիքը</b></td>
<td><b>Տևողությունը</b></td>
<td><b>Անվանումը/նկարագրությունը</b></td>
</tr>
"

	curl -s "$cmdurl" | while read line
	do
		[[ "$line" == "<e2movie>" ]] && echo "<tr>" && continue
		[[ "$line" == "</e2movie>" ]] && echo "<td>$svcname</td>" && echo "<td>$length</td>" && echo "<td>$title</td>" && echo "</tr>" && continue
		[[ "$line" =~ ^\<e2servicename\>(.+)\<\/e2servicename\>$ ]] && svcname="${BASH_REMATCH[1]}" && continue
		[[ "$line" =~ ^\<e2title\>(.+)\<\/e2title\>$ ]] && title=${BASH_REMATCH[1]} && continue
		[[ "$line" =~ ^\<e2description\>(.+)\<\/e2description\>$ ]] && title="$title${BASH_REMATCH[1]}" && continue
		[[ "$line" =~ ^\<e2length\>(.+)\<\/e2length\>$ ]] && length=${BASH_REMATCH[1]} && continue
	done

	echo "
</table>
</body>
</html>
" ) | gzip | curl --upload-file - "http://shah32768.sdf.org/cgi-bin/vu-upload.cgi?33462e45-2031-4dab-a821-1e7cac6a7d3d" 
}


