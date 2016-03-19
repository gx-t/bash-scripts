#!/usr/bin/env bash
ls *.mp4 | while read ff
do
	avconv -i "$ff" -target pal-dvd "$ff".mpeg
done

