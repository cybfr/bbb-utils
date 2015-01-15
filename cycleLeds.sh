#!/bin/bash
set -x
BASE=/sys/class/leds/beaglebone\:green\:usr
states="1111 1011 1101 1110"
init () {
  for i in `seq 0 3` ; do
   echo "none" >/${BASE}$i/trigger
   echo 0  >/${BASE}$i/brightness
  done
}
seq () {
for state in $states ; do
  echo -n "$state " 
  for i in `seq 0 3` ; do
    echo ${state:${i}:1} >${BASE}${i}/brightness
  done
  sleep 0.5s
done
}
reset () {
for i in `seq 0 3` ; do
 echo "none" >/${BASE}$i/trigger
 echo 0  >/${BASE}$i/brightness
done
}
init
seq
reset
