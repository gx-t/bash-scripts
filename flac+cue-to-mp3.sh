#!/usr/bin/env bash
#Usage: flac+cue-to-mp3 < cuefile | bash
#Dependencies: bash, awk, sox, libsox-fmt-mp3, id3v2


awk '
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  BEGIN {count=0;}
  /^REM\s+DATE\s+[0-9][0-9][0-9][0-9]/ {year=$3}
  /^PERFORMER/ {performer=rtrim(substr($0,index($0,$2)))}
  /^TITLE/ {title=rtrim(substr($0,index($0,$2)))}
  /^FILE/ {infile=rtrim(substr($0,index($0,$2))); infile=substr(infile, 0, length(infile) - length($NF))}
  /^\s+TITLE/ {title_arr[count]=rtrim(substr($0,index($0,$2)))}
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
      mp3file = title_arr[idx]".mp3";
      printf("( sox %s -C 320 \"%02d \"%s trim %g %g ; id3v2 -y %d -a %s -A %s -t %s -T %d -c \"\" \"%02d \"%s ) &\n",
        infile, idx+1, mp3file, time_arr[idx], len, year, performer, title, title_arr[idx], idx+1, idx + 1, mp3file);
    }
  }
'

