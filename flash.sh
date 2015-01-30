#!/bin/bash
NUM=3
ROOT_PART=$(mount | grep " / "|cut -d\  -f1)
SRC=${ROOT_PART%*p?}
DST=$(ls -1 /dev/mmcblk?|grep -v $SRC)

SRC="/media/img/my_rootfs-debian-8.0-console-armhf-2015-01-29-2gb.img"

echo "Will copy $SRC => $DST"
echo -n "Do it ? yes/NO " ; read rep
if [[ "${rep}x" = "yesx" ]] 
then

  # Prepare emmc
  echo  "Erasing: ${DST}"
  echo  "First pass"
  pv </dev/zero >${DST} -Ss108m
  echo  "Second pass"
  pv >/dev/null <${DST} -Ss108m
  echo "Erasing: ${DST} complete"
  echo "Writing bootloader to [${DST}]"
  echo "MLO first pass"
  pv </opt/backup/uboot/MLO | dd of=${DST} count=1 seek=1 conv=notrunc bs=128k 2>/dev/null
  echo "MLO second pass"
  pv </opt/backup/uboot/MLO | dd of=${DST} count=1 seek=1 conv=notrunc bs=128k 2>/dev/null
  echo "U-boot first pass"
  pv </opt/backup/uboot/u-boot.img | dd of=${DST} count=2 seek=1 conv=notrunc bs=384k 2>/dev/null
  echo "U-boot second pass"
  pv </opt/backup/uboot/u-boot.img | dd of=${DST} count=2 seek=1 conv=notrunc bs=384k 2>/dev/null
  echo "Partitionning: ${DST}"
  LC_ALL=C sfdisk --force --in-order --Linux --unit M "${DST}" &>/dev/null  <<-__EOF__
			1,,0x83,*
		__EOF__
  echo "Writing  ${SRC} on ${DST}p1"
  pv <${SRC} >"${DST}p1"
fi

echo -n  "Syncing... "
sync
blockdev --flushbufs ${DST}
echo "done"

umount /target &>/dev/null
umount ${DST}p1 &>/dev/null
echo "Checking new filesystem"
fsck -fTCp ${DST}p1 &>/dev/NULL  || exit 2
echo "resizing"
sfdisk --force --no-reread --in-order --Linux --unit M ${DST} &>/dev/null <<-__EOF__
		1,,0x83,*
	__EOF__
resize2fs /dev/mmcblk1p1 &>/dev/null
tune2fs -L "niel-${NUM}" -U random /dev/mmcblk1p1 &>/dev/null

mount ${DST}p1 /target
sed -i "s/-x/-${NUM}/" /target/etc/hostname
# sed -i "s/NUM=$((NUM++))/NUM=$NUM/" /root/bbb-utils/flash.sh
rm -f /target/etc/ssh/ssh_host_{dsa,rsa,ecdsa}_key{.pub,}
ssh-keygen -q -f /target/etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -q -f /target/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521

umount /target
