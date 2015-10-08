#!/usr/bin/env bash

url=$(xclip -o)
url=$(zenity --width=320 --title="Բեռնել youyube -ից" --ok-label="Սկսել" --entry --text="Հասցեն․" --entry-text="$url")
youtube-dl -c -l $url | while read line
do
	echo "# $line"
done |
zenity --progress   --title="Բեռնում youyube -ից..."   --text=""   --pulsate --auto-kill

