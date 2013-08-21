#!/bin/bash
#---
if ! streamripper --version >& /dev/null
then
  zenity --error --text="<b>streamripper</b> ծրագիրը <i>հասանելի չէ</i>, <b>տեղադրեք</b> այն և կրկին փորձեք"
  exit 1
fi
cd ~/Music
if ! cd Radio
then
mkdir Radio
fi
cd Radio
if st=$(zenity --title "Ընտրեք ռարիոկայանը..." --list --radiolist --width=600 --height=300 --text="" \
  --column "" --column="Կայանի Անվանումը" --column="URL" --hide-column=3 --print-column=3 \
  "" "Mostly Classical - SKY.FM - Listen and Relax, it's good for you! www.sky.fm" "http://stream-135.shoutcast.com:80/classical_skyfm_mp3_96kbps" \
  "" "POLSKASTACJA .PL --- - Mocne Brzmienie Rocka (Polskie Radio),aacplus" "http://91.121.249.18:80" \
  "" "Pirate Radio KQLZ Los Angeles  - 80s and 90s Pop Rock" "http://174.127.65.10:80" \
  "" "Հայ FM" "http://195.250.70.22:8000/HayFm" \
  "" "Ռադիո Հայ (Rock)" "http://195.250.70.22:8000/Rock" \
  "" "Ռադիո Հայ (Jazz)" "ttp://195.250.70.22:8000/Jazz")
then
  if [ -z $st ]
  then
    zenity --info --title "Հասցեն դատարկ է" --text "Դուք չեք ընտրեն որևէ կայան, ներբեռնում չի կատարվելու"
    exit 2
  fi
  streamripper $st -q  | zenity --title 'Ներբեռնում է...' --info \
  --text="URL=$st
Ներբեռնումը դադարեցնելու համար սեղմեք 'Ok'\n
Ներբեռնված Ֆայլերը գտնվում են՝
~/Music/Radio/=Կայանի անվանումը=
պանակում"
fi

