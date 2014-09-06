#!/usr/bin/env bash

! cd Դասեր 2> /dev/null && echo "Չի ստացվում տեղափոխվել «Դասեր»։ Ստուգեք ճանապարհը։" >&2 && exit 1

#մուտքային ֆայլերը վերածում է կանոնավոր աղյուսակի ֊ հավասար սյունյակների քանակ ունեցող
make_table() {
  local name
  declare -a line
  local price
  local vp_month
  declare -a dt
  local idx
#ֆայլի անունը ֊ ուսանողի անունն է
  while read name
  do
#    echo "$name ․․․" >&2
    cat "$name" | {
      name=${name//\ /_}
#առաջին երկու տողերը ֊ մեկ դասի գումարը և մեկ ակադեմիական ամսում պարապմունքների քանակն է
      read price && read vp_month &&
      while read -a line
      do
#տողը պետք է պարունակի 2 կամ 3 դաշտ
        ((${#line[@]} != 2 && ${#line[@]} != 3 )) && continue
        dt=(${line[1]//./" "})
#դաս՝ + օր․ամիս․տարի
# + 29.01.14
        ((${#line[@]} == 2 )) && [[ ${line[0]} == + ]] &&
          printf "%s-%s %s %s %s %s %d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month 0 &&
          continue
#մուծում՝ գումար օր․ամիս․տարի
# 5000 29.01.14
        ((${#line[@]} == 2 )) && [[ ${line[0]} != + ]] &&
          printf "%s-%s %s %s %s %s %d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month ${line[0]} &&
          continue
#դաս և մուծում՝ + օր․ամիս․տարի գումար
# + 29.01.14 5000
        ((${#line[@]} == 3)) &&
          printf "%s-%s %s %s %s %s %d\n" ${dt[2]} ${dt[1]} ${dt[0]} "$name" $price $vp_month  ${line[2]}
          continue
      done
    }
  done
}

process() {
  declare -A income
  declare -A lessons
  declare -a line
  while read -a line
  do
    ((income[${line[0]}_${line[2]}] += ${line[5]}))
    ((lessons[${line[0]}_${line[2]}] += ${line[3]}))
#    echo ${line[2]}
  done
  local idx_sorted=${!income[@]}
  idx_sorted=$(sort <<< "${idx_sorted// /$'\n'}")
  for idx in $idx_sorted
  do
    local month=${idx:0:5}
    local name=${idx:6}
#    echo "m=$month, n=$name"
    local diff
    ((diff = ${income[$idx]} - ${lessons[$idx]}))
    printf "$month, ${name/_/ }, Մուտքերը՝ ${income[$idx]}, Դասերը՝ ${lessons[$idx]}, Տարբերությունը՝ $diff\n"
  done
#    ((income[${line[0]}] += ${line[5]}))
}


ls | make_table | process

