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
#    echo "$name ․․․" >&2
    cat "$name" | {
      name=${name//\ /_}
      read price && read vp_month &&
      while read -a line
      do
        ((${#line[@]} != 2 && ${#line[@]} != 3 )) && continue
        dt=(${line[1]//./" "})
        ((${#line[@]} == 2 )) && [[ ${line[0]} == + ]] &&
          printf "${dt[2]}-${dt[1]} $name $price $vp_month 0\n" &&
          continue
        ((${#line[@]} == 2 )) && [[ ${line[0]} != + ]] &&
          printf "${dt[2]}-${dt[1]} $name $price $vp_month ${line[0]}\n" &&
          continue
        ((${#line[@]} == 3)) &&
          printf "${dt[2]}-${dt[1]} $name $price $vp_month  ${line[2]}\n" &&
          continue
      done
    }
  done
}

process() {
  local stpm_payment
  local pm_payment
  local last_month
  local last_name
  declare -a line
  while read -a line
  do
    local month=${line[0]}
    local name=${line[1]}
    local price=${line[2]}
    local vp_month=${line[3]}
    local payment=${line[4]}
    
    last_month=${last_month:-$month}
    last_name=${last_name:-$name}
    ((pm_payment += $payment))
    ((stpm_payment += $payment))
    [[ $last_month != $month ]] &&
    {
      echo "MONTH CHANGE ($last_month:$pm_payment, $last_name:$stpm_payment)"
      pm_payment=0
      stpm_payment=0
    } && last_month=$month

    [[ $last_name != $name ]] &&
    {
      echo "NAME CHANGE ($last_name:$stpm_payment)"
      stpm_payment=0
    } && last_name=$name

    echo "m=$month, n=$name, p=$price, v=$vp_month, p=$payment"
  done
  echo "END ($last_month:$pm_payment, $last_name:$stpm_payment)"
}

ls | make_table | sort | process

