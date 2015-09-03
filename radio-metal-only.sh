#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://80.237.225.70:9480'
out='radio-metal-only'
streamripper "$url" -l $length $options "$out"

