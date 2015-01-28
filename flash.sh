#!/bin/bash
NUM=1
ROOT_PART=$(mount | grep " / "|cut -d\  -f1)
SRC=${ROOT_PART%*p?}
DST=$(ls -1 /dev/mmcblk?|grep -v $SRC)

echo "$SRC => $DST"
echo -n "Do it ? yes/NO " ; read rep


if [[ "${rep}x" = "yesx" ]] 
then
dd if=/dev/zero of=$DST ds=1M count=10
dd if=${SRC} of=${DST} bs=1M count=1900 &
PID=$!
echo "/proc/$PID"

while [ -d /proc/${PID} ] ; do
  sleep 2s
  kill -USR1 ${PID}
  sleep 18s
done
fi
sync
blockdev --flushbufs ${destination}

umount /target
umount ${DST}p1
fsck ${DST}p1
tune2fs -L "niel-${num}" $DST
mount ${DST}p1 /target
sed -i "s/-x/-${NUM}/" /target/etc/hostname
sed -i "s/NUM=$((NUM++))/NUM=$NUM/" /root/bbb-utils/flash.sh
rm -f /target/etc/ssh/ssh_host_{dsa,rsa,ecdsa}_key{.pub,}
ssh-keygen -q -f /target/etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521

umount /target
