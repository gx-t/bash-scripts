#!/usr/bin/env bash

! cd Դասեր 2> /dev/null && echo "Չի ստացվում տեղափոխվել «Դասեր»։ Ստուգեք ճանապարհը։" >&2 && exit 1

make_table() {
  local name
  declare -a line
  local price
  local vp_month
  declare -a dt
  local idx
  while read name
  do
    echo "$name ․․․" >&2
    cat "$name" | {
      read price && read vp_month &&
      while read -a line
      do
        ((${#line[@]} != 2 && ${#line[@]} != 3 )) && continue
        dt=(${line[1]//./" "})
        ((${#line[@]} == 2 )) && [[ ${line[0]} == + ]] &&
          printf "դաս\t%s-%s\t%s\t\"%s\"\t%s\t%s\t%d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month 0 &&
          continue
        ((${#line[@]} == 2 )) && [[ ${line[0]} != + ]] &&
          printf "մուտք\t%s-%s\t%s\t\"%s\"\t%s\t%s\t%d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month ${line[0]} &&
          continue
        ((${#line[@]} == 3)) &&
          printf "դաս\t%s-%s\t%s\t\"%s\"\t%s\t%s\t%d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month 0 &&
          printf "մուտք\t%s-%s\t%s\t\"%s\"\t%s\t%s\t%d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month ${line[2]} &&
          continue
      done
    }
  done
}


ls | make_table

