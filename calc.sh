#!/usr/bin/env bash

! cd Դասեր 2> /dev/null && echo "Չի ստացվում տեղափոխվել «Դասեր»։ Ստուգեք ճանապարհը։" >&2 && exit 1

make_table() {
  local debt
  local income=0
  local lesson_count=0
  local last_month
  local name
  declare -a line
  local price
  local vp_month
  declare -a dt
  while read name
  do
    echo "$name ․․․" >&2
    cat "$name" | {
      name=${name//\ /_}
      read price && read vp_month &&
      while read -a line
      do
        ((${#line[@]} != 2 && ${#line[@]} != 3 )) && continue
        dt=(${line[1]//./" "})
        local month="${dt[2]}/${dt[1]}"
        last_month=${last_month:-$month}
        [[ $last_month != $month ]] &&
        {
          ((debt=$income/$price-$lesson_count))
          echo "$last_month $name $income $lesson_count $debt $price"
          income=0
          lesson_count=0
          last_month=$month
        }
        ((${#line[@]} == 2 )) && [[ ${line[0]} == + ]] && ((lesson_count++)) &&
          continue
        ((${#line[@]} == 2 )) && [[ ${line[0]} != + ]] && ((income+=${line[0]})) &&
          continue
        ((${#line[@]} == 3)) && ((lesson_count++)) && ((income+=${line[2]})) &&
          continue
      done
      ((debt=$income/$price-$lesson_count))
      echo "$last_month $name $income $lesson_count $debt $price"
    }
  done
}

process() {
  local income=0
  local debt=0
  local debt_dr=0
  local st_debt=0
  local last_month
  declare -a line
  while read -a line
  do
    last_month=${last_month:-${line[0]}}
    [[ $last_month != ${line[0]} ]] &&
    {
      echo "Տարին/ամիսը........... $last_month"
      echo "Աշակերտի անունը....... Բոլորը միասին"
      echo "Գումարային մուտքերը... $income dram"
      (($debt < 0)) || echo "Իմ Պարտքը............. $debt դաս"
      (($debt_dr < 0)) || echo "Աշակերտների պարտքը.... $debt_dr դրամ"
      income=0
      debt=0
      last_month=${line[0]}
      echo "======================"
      echo
    }
    ((income += ${line[2]}))
    ((debt += ${line[4]}))
    ((debt_dr += -${line[4]} * ${line[5]}))
    ((st_debt = -${line[4]} * ${line[5]}))
    echo "Տարին/ամիսը........... $last_month"
    echo "Աշակերտի անունը....... ${line[1]//_/\ }"
    echo "Մուտքերը.............. ${line[2]} դրամ"
    echo "Դասերի քանակը......... ${line[3]}"
    ((${line[4]} < 0)) || echo "Իմ Պարտքը............. ${line[4]} դաս"
    (($st_debt < 0)) || echo "Աշակերտի պարտքը....... $st_debt դրամ"
    echo "Մեկ դասի արժեքը....... ${line[5]} դրամ"
    echo "---------------"
    echo
    
#    echo "m=${line[0]},n=${line[1]},i=${line[2]},c=${line[3]},d=${line[4]},p=${line[5]}"
  done
  echo "Տարին/ամիսը........... $last_month"
  echo "Աշակերտի անունը....... Բոլորը միասին"
  echo "Գումարային մուտքերը... $income dram"
  (($debt < 0)) || echo "Իմ Պարտքը............. $debt դաս"
  (($debt_dr < 0)) || echo "Աշակերտների պարտքը.... $debt_dr դրամ"
  echo "======================"
}

ls | make_table | sort -r | process > ../Հաշվետվություն.txt
gedit ../Հաշվետվություն.txt

