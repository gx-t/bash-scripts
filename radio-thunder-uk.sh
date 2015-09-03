#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://listen.radionomy.com/Radio-Thunder-UK'
out='Radio Thunder UK'
streamripper "$url" -l $length $options "$out"

