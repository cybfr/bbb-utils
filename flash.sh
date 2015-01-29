#!/bin/bash
NUM=2
ROOT_PART=$(mount | grep " / "|cut -d\  -f1)
SRC=${ROOT_PART%*p?}
DST=$(ls -1 /dev/mmcblk?|grep -v $SRC)

SRC="/media/img/my_rootfs-debian-8.0-console-armhf-2015-01-29-2gb.img"

echo "$SRC => $DST"
echo -n "Do it ? yes/NO " ; read rep


if [[ "${rep}x" = "yesx" ]] 
then
  echo "Flashing eMMC"
  pv <${SRC} >${DST} -Ss 1832M
fi

sync
blockdev --flushbufs ${DST}

umount /target &>/dev/null
umount ${DST}p1 &>/dev/null
echo "Checking new filesystem"
fsck -fTCp ${DST}p1 || exit 2
tune2fs -L "niel-${NUM}" -U random /dev/mmcblk1p1 &>/dev/null
mount ${DST}p1 /target
sed -i "s/-x/-${NUM}/" /target/etc/hostname
# sed -i "s/NUM=$((NUM++))/NUM=$NUM/" /root/bbb-utils/flash.sh
rm -f /target/etc/ssh/ssh_host_{dsa,rsa,ecdsa}_key{.pub,}
ssh-keygen -q -f /target/etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521

umount /target
