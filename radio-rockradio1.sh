#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://91.121.7.49:8000'
out='radio-rockradio1'
streamripper "$url" -l $length $options "$out"

