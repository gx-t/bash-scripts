#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://174.127.65.10:80'
out='radio-pirate-radio'
streamripper "$url" -l $length $options "$out"

