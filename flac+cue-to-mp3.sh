#!/usr/bin/env bash
#Usage: flac+cue-to-mp3 < cuefile | bashs
#Dependencies: bash, awk, sox, libsox-fmt-mp3, mp3info


awk '
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  BEGIN {count=0;}
  /^PERFORMER/ {performer=substr($0,index($0,$2))}
  /^TITLE/ {title=substr($0,index($0,$2))}
  /^FILE/ {infile=substr($0,index($0,$2)); sub(/\r/, "", infile); infile=substr(infile, 0, length(infile) - length($NF))}
  /^\s+TITLE/ {title_arr[count]=substr($0,index($0,$2)); sub(/\r/, "", title_arr[count])}
  /^\s+INDEX\s+[0-9]+\s+[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/ {
    time_arr[count]=substr($0,index($0,$3));
    time_arr[count]=substr(time_arr[count], 0, 2) * 60 + substr(time_arr[count], 4, 2) + substr(time_arr[count], 7, 2) * 0.01
    count++
  }
  END {
    printf("title=%s\nperformer=%s\n", title, performer)
    for(idx=0; idx < count; idx++)
    {
      len=time_arr[idx+1] - time_arr[idx];
      if(len < 0) len = -1;
      printf("sox %s -C 320 \"%02d \"%s trim %g %g &\n", infile, idx+1, title_arr[idx]".mp3", time_arr[idx], len);
    }
  }
'

