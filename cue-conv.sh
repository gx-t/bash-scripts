#!/usr/bin/env bash
REM() {
  if [ $1 == "DATE" ]
  then
    year=$2
    return
  fi
  if [ $1 == "GENRE" ]
  then
    genre="$2"
  fi
}

PERFORMER() {
  artist="$1"
}

TITLE() {
  album="$1"
}

FILE() {
  file="$1"
}

TRACK() {
  echo "Track = $1"
  track=$1
  TITLE() {
    echo "Title2 = $1"
  }
  PERFORMER() {
    echo "Performer2 = $1"
  }
  INDEX() {
    echo "Index = $1 pos = $2"
  }
}

while read line
do
  eval "$line"
done

echo "year=$year"
echo "genre=$genre"
echo "artist=$artist"
echo "album=$album"
echo "file=$file"

