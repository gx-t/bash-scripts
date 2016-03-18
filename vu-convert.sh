#!/usr/bin/env bash
src=/mnt/vu/*.ts
[[ $# != 1 ]] && echo "Usage: $0 <file count>" && exit 1
ls -t $src | head -n $1  | while read ff
do
	opt=$(avprobe "$ff" 2>&1 |
	while read line
	do
		[[ "$line" =~ ^Stream.+([0-9])\.([0-9]).+Audio.+$ ]] && echo -en " -map ${BASH_REMATCH[1]}:${BASH_REMATCH[2]} -c:a copy"
		[[ "$line" =~ ^Stream.+([0-9])\.([0-9]).+Video.+$ ]] && echo -en " -map ${BASH_REMATCH[1]}:${BASH_REMATCH[2]} -c:v libx264"
	done
	[[ "$ff" =~ ^.+\ HD\ .+.ts$ ]] && echo -en " -s 1280x720")
	avconv -i "$ff" $opt -y "$(basename "$ff")"
done

