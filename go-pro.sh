#!/usr/bin/env bash

fix-fisheye() {
	local src=/media/$USER/*/DCIM/*/GOPR[0-9][0-9][0-9][0-9].JPG
	ls $src | while read ff
	do
		echo "$(basename $ff) ..."
		convert "$ff" -distort barrel '0.06335 -0.18432 -0.13009' "$(basename $ff)"
#		convert "$ff" -distort barrel '0.10,-0.32,0' "$(basename $ff)"
#		convert "$ff" -distort barrel '0,0,-0.3' "$(basename $ff)"
	done
}


jpegs-to-ts() {
	local src=/media/$USER/*/DCIM/*/G*[0-9][0-9][0-9][0-9].JPG
	local out="$(date).ts"
#	local size="1600x1200"
	local size="1280x960"
	local tmpdir=$(mktemp)
	rm -rf $tmpdir
	mkdir $tmpdir || return
	i=0
	echo "Creating input files links..."
	ls $src | while read ff; do ln -sf "$ff" "$tmpdir/$(printf '%08d.jpeg' $i)"; (( i ++ )); done
	echo "Converting to movie..."
	avconv -i "$tmpdir/%08d.jpeg" -s "$size" -c:v libx264 "$out"
	rm -rf "$tmpdir"
}


mp4s-to-single() {
	local src=/media/$USER/*/DCIM/*/GOPR[0-9][0-9][0-9][0-9].MP4
	local size="1280x720"
#	local rate=120
	local rate=30
	ls -tr $src | while read ff; do avconv -i "$ff" -s "$size" -vcodec rawvideo -r $rate -f avi -; done | avconv -i - "$(date).mkv"
}
