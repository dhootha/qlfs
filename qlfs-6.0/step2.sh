#!/bin/bash
# Questo file e' lanciato da root
source /tmp/lfs/lfs-utils
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs60
source /tmp/lfs/language
export LFS=/mnt/lfs

#language
#set_language

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"############################################" && \
echo "#  Mounting the proc and devpts file systems" && \
echo "############################################"$(echo $REPLACE) && \
mkdir -p $LFS/{proc,sys} && \
mount -t proc proc $LFS/proc && \
mount -t sysfs sysfs $LFS/sys && \
mount -f -t ramfs ramfs $LFS/dev && \
mount -f -t tmpfs tmpfs $LFS/dev/shm && \
mount -f -t devpts -o gid=4,mode=620 devpts $LFS/dev/pts && \
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"#################################" && \
echo "# Entering the chroot environment" && \
echo "#################################"$(echo $REPLACE) && \
echo ""

#COPIA DEI NUOVI SCRIPT NELLA PARTIZIONE $LFS
cp /tmp/lfs/step3.sh $LFS && \
cp /tmp/lfs/step4.sh $LFS && \
cp /tmp/lfs/step5.sh $LFS && \
cp /tmp/lfs/step6.sh $LFS && \
cp /tmp/lfs/lfs-var $LFS && \
cp /tmp/lfs/lfs-utils $LFS && \
cp /tmp/lfs/lfs60 $LFS && \
cp /tmp/lfs/language $LFS && \
chmod 777 $LFS/step* && \
cp /tmp/lfs/defconfig $LFS && \

echo -e $(echo $COLOR_GREEN_LIGHT)$STTDF $(echo $REPLACE) && \
chroot "$LFS" /tools/bin/env -i \
HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
/tools/bin/bash --login +h

