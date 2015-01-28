#!/bin/bash
NUM=4
ROOT_PART=$(mount | grep " / "|cut -d\  -f1)
SRC=${ROOT_PART%*p?}
DST=$(ls -1 /dev/mmcblk?|grep -v $SRC)

echo "$SRC => $DST"
if false
then

dd if=${SRC} of=${DST} bs=1M icount=1800 &
PID=$!
echo "/proc/$PID"

while [ -d /proc/${PID} ] ; do
  sleep 1s
  kill -USR1 ${PID}
  sleep 9s
done
fi
umount /target
umount ${DST}p1
fsck ${DST}p1
mount ${DST}p1 /target
sed -i "s/-x/-${NUM}/" /target/etc/hostname
sed -i "s/NUM=$((NUM++))/NUM=$NUM/" /root/bbb-utils/flash.sh
rm -f /target/etc/ssh/ssh_host_{dsa,rsa,ecdsa}_key{.pub,}
ssh-keygen -q -f /target/etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521

umount /target
