#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://listen.radionomy.com/Goth-N-Metal'
out='radio-goth-n-metal'
streamripper "$url" -l $length $options "$out"

