#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://91.121.103.183:6200'
out='radio-polskastancija'
streamripper "$url" -l $length $options "$out"

