#!/usr/bin/env bash
ss=(`identify -format "%[exif:GPSLatitude] %[exif:GPSLatitudeRef] %[exif:GPSLongitude] %[exif:GPSLongitudeRef]" "$1" | tr "," " "`)
if [ ${#ss[@]} != 8 ]
then
  zenity --warning --title="Ֆայլը չունի GPS տվյալներ" --text="$1"
  exit 1
fi
sensible-browser "https://www.google.com/maps/place/
$(bc <<< ${ss[0]})°
$(bc <<< ${ss[1]})'
$(bc <<< "scale=10;${ss[2]}")\"
${ss[3]}+$(bc <<< ${ss[4]})°
$(bc <<< ${ss[5]})'
$(bc <<< "scale=10;${ss[6]}")\"
${ss[7]}"

