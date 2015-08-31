#!/usr/bin/env bash

fix-fisheye() {
	local src=/media/$USER/*/DCIM/*/GOPR[0-9][0-9][0-9][0-9].JPG
	ls $src | while read ff
	do
		echo "$(basename $ff) ..."
#		convert "$ff" -distort barrel '0.06335 -0.18432 -0.13009' "$(basename $ff)"
#		convert "$ff" -distort barrel '0.10,-0.32,0' "$(basename $ff)"
		convert "$ff" -distort barrel '0,0,-0.3' "$(basename $ff)"
	done
}

