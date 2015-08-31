#!/usr/bin/env bash

fix-fisheye() {
	local src=/media/shah/disk/DCIM/*/GOPRO[0-9][0-9][0-9][0-9].JPG
	ls "$src" | while read ff
	do
		convert "$ff" -distort barrel '0.06335 -0.18432 -0.13009' "$(basename $ff)"
	done
}

