#!/bin/bash
BASE="/sys/class/leds/beaglebone:green:usr"
states="\
1000 \
1100 \
1110 \
1111 \
0111 \
0011 \
0001 \
0000 \
"
function reset_leds {
  for i in `seq 0 3` ; do
   echo "none" >${BASE}$i/trigger
   echo 0  >${BASE}$i/brightness
  done
}
led_seq () {
for state in $states ; do
  for i in `seq 0 3` ; do
    echo ${state:${i}:1} >${BASE}${i}/brightness
  done
  sleep 0.1s
done
}
reset_leds
for j in `seq 1 10`; do
  sleep 1s
  led_seq
done
reset_leds
