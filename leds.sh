#/bin/bash
ledPath="/sys/class/leds/"
function getLedState {
  trigger=$(cut -d[ -f2 $1/trigger |cut -d] -f1 )
  case $trigger in
    none)
      brightness=$(cat ${1}/brightness)
        state="on"
      [[ "$brighness" == "0" ]] || state=off
      echo "$trigger, $state"
    ;;
    timer)
      echo "$trigger, $(cat ${1}/delay_on)/$(cat ${1}/delay_off)"
    ;;
    *)
    echo $trigger
    ;;
  esac
}


case "$1" in
  off)
    for led in `ls ${ledPath}`; do  echo "none" > "${ledPath}${led}/trigger"; done
  ;;
  on)
    echo heartbeat >"/sys/class/leds/beaglebone:green:usr0/trigger"
    echo mmc0 >/sys/class/leds/beaglebone\:green\:usr1/trigger
    echo cpu0 >/sys/class/leds/beaglebone\:green\:usr2/trigger
    echo mmc1 >/sys/class/leds/beaglebone\:green\:usr3/trigger
  ;;
  *)
    for led in `ls ${ledPath}`; do  
     trigger=$(getLedState ${ledPath}${led})
     echo "led ${led##*:} : $trigger "
    done
  ;;
esac
