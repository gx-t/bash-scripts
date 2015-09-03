#!/usr/bin/env bash
length=3600

#Single file output:
#options='-q -A -a'

#Many numbered files + all in a single file:
options='-q -a'

url='http://pub7.rockradio.com/rr_symphonicmetal'
out='radio-rockradio-symphonic-metal'
streamripper "$url" -l $length $options "$out"

