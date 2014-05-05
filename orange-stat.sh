#!/usr/bin/env bash
awk 'BEGIN {
  printf("Մուտք արեք tab բաժանիչով 7 սյունյականի աղյուսակ...\n") > "/dev/stderr";
  FS="\t";
}
{
  if($6 ~ /^[0-9]+$/)
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
  printf("*******************************************************************************\n") > "/dev/stderr";
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
    printf("%40s՝ %g sec, %g դրամ (%g դրամ/րոպե)\n", idx, time[idx], cost[idx], 60*cost[idx]/time[idx]);
  }
  if(total_time != 0)
  {
    printf("%40s՝ %g sec, %g դրամ (%g դրամ/րոպե)\n", "Բոլորը", total_time, total_cost, 60*total_cost/total_time);
    if(totno_time != 0)
    {
      printf("%40s՝ %g sec, %g դրամ (%g դրամ/րոպե)\n", "Բոլորը բացի Orange֊ից", totno_time, totno_cost, 60*totno_cost/totno_time);
    }
  }
}'

