#!/usr/bin/env bash

scan-table() {
  gawk 'BEGIN {
    FS="\t";
  }
  {
    if($6 ~ /^[0-9]+$/ && $4 ~ /^[0-9]+:[0-9]+:[0-9]+$/)
    {
      name=$5;
      if(name=="") name="Orange";
      cost[name]+=$6;
      sec = $4
      gsub("\\:", " ", sec);
      sec=mktime("0 0 0 "sec) - mktime("0 0 0 0 0 0");
      time[name]+=sec;
    }
  }
  END {
    total_time=0;
    totno_time=0;
    total_cost=0;
    totno_cost=0;
    for(idx in cost)
    {
      total_time+=time[idx];
      total_cost+=cost[idx];
      if(idx != "Orange")
      {
        totno_time+=time[idx];
        totno_cost+=cost[idx];
      }
      if(time[idx] == 0) continue;
      printf("%s\n%g\n%g\n%g\n", idx, time[idx]/60, cost[idx], cost[idx]*60/time[idx]);
    }
  }'
}

process-data() {
  local i=0
  local arr
  while read data
  do
    arr[$i]=$data
    ((i++))
  done
  for((i=0; i<${#arr[@]}; i++))
  do
    echo ${arr[$i]}
  done
}

scan-table | process-data


