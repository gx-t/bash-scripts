#!/usr/bin/env bash
[[ $# != 1 ]] && echo "Usage: $0 <ts file>" && exit 1
ff="$1"
opt=$(avprobe "$ff" 2>&1 |
		while read line
		do
		[[ "$line" =~ ^Stream.+([0-9])\.([0-9]).+Audio.+$ ]] && echo -en " -map ${BASH_REMATCH[1]}:${BASH_REMATCH[2]} -c:a copy"
		[[ "$line" =~ ^Stream.+([0-9])\.([0-9]).+Video.+$ ]] && echo -en " -map ${BASH_REMATCH[1]}:${BASH_REMATCH[2]} -c:v libx264"
		done
		[[ "$ff" =~ ^.+\ HD\ .+.ts$ ]] && echo -en " -s 1280x720")
avconv -i "$ff" $opt -f matroska - | curl -X PUT --upload-file "-" https://transfer.sh/test.mkv

