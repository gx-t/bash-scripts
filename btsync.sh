#!/bin/bash

bs-start() {
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

tr-night() {
  echo $(date)
  echo "Waiting for night time to start transmission-gtk..."
  sleep $(time_to "02:00")
  transmission-gtk &
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
  streamripper http://174.127.65.10:80 -a radio
  popd
}

radio-download-polskastancia() {
  pushd .
  _radio-goto-dir
#  streamripper http://91.121.249.18:80 -a radio
  streamripper http://91.121.103.183:6200 -q
  popd
}

radio-download-rock-only() {
  pushd .
  _radio-goto-dir
  streamripper http://80.237.225.70:9480 -a radio
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
    res = n1;
    if(n2 > res) res = n2;
    if(n3 > res) res = n3;
    return res;
  }
  /^[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a1[c1++]=$1;}
  /^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ][ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+$/ {a2[c2++]=$1;}
  /^[ա-ստ֊ևԱ-ՍՏ֊Ֆ՞՜]+[վՎ]$/ {a3[c3++]=$1;}
  END {
    n1=asort(a1);
    n2=asort(a2);
    n3=asort(a3);
    cnt = max(n1,n2,n3);
    for(i=1;i<=cnt;i++) {
      printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", a1[i], a2[i], a3[i]);
    }
    printf("</table></body></html>\n");
  }'
}


