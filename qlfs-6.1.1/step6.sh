#!/bin/bash

source /tmp/lfs/lfs-utils
source /tmp/lfs/language
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs61

#language
#set_language


#PER SICUREZZA 
export LFS=/mnt/lfs

echo $(echo $COLOR_GREEN_LIGHT)"###################################" && \
echo  $STTNRS && \
echo "###################################" && \
echo "" && \
echo $STTWP $(echo $REPLACE) && \
rm -r /mnt/lfs/sources && \
rm -r /mnt/lfs/tools && \
rm /tools && \
rm /mnt/lfs/*sh && \
rm /mnt/lfs/lfs-* && \
rm /mnt/lfs/language && \
### UMOUNT ###
umount $LFS/dev/pts
umount $LFS/dev/shm
umount $LFS/dev
umount $LFS/proc
umount $LFS/sys
#umount /mnt/lfs && \

echo -e $(echo $COLOR_GREEN_LIGHT)$STTBLS $(echo $REPLACE) && \
read risp
#echo $(echo $COLOR_PURPLE) $STTDP $(echo $REPLACE)
#read path
path=$hdax
dev=$(device "$path")
par=$(partition "$path")
######### DA SISTEMARE!!!!! ############
if [[ $risp == "G" || $risp == "g" ]]
then
	echo "" >> /boot/grub/menu.lst && \
	echo "# QLFS 6.1" >> /boot/grub/menu.lst && \
	echo "title   QLFS 6.1, kernel 2.6.11.12" >> /boot/grub/menu.lst && \
	echo "root    (hd$dev,$par)" >> /boot/grub/menu.lst && \
	echo "kernel  /boot/lfskernel-2.6.11.12 root=$path " >> /boot/grub/menu.lst && \
	echo "" && \
	echo -e $(echo $COLOR_PURPLE)$STTAR $(echo $REPLACE) && \
	read reboot_risp && \
	if [[ $reboot_risp = "" ]]
	then
		echo $(echo $COLOR_GREEN_LIGHT)$SRAT $(echo $REPLACE) && \
		umount /mnt/lfs &> /dev/null && \
		reboot
	else
		echo $(echo $COLOR_GREEN_LIGHT)$SRMT$(echo $REPLACE) && \
		umount /mnt/lfs &> /dev/null && \
		exit 0
	fi
		
elif [[ $risp == "L" || $risp == "l" ]]
then
	cp /etc/lilo.conf /etc/lilo.conf.lfs-save && \
	cp /mnt/lfs/boot/lfskernel-2.6.8.1  /boot/lfskernel-2.6.8.1  && \
	umount /mnt/lfs &> /dev/null && \
	echo "" >> /etc/lilo.conf && \
	echo "image=/boot/lfskernel-2.6.11.12 " >> /etc/lilo.conf && \
	echo "label=QLFS 6.1" >> /etc/lilo.conf && \
	echo "root=$path" >> /etc/lilo.conf && \
	echo "read-only" >> /etc/lilo.conf && \
	lilo -v && \
	echo "" && \
	echo -e $(echo $COLOR_PURPLE)$STTAR$(echo $REPLACE) && \
        read reboot_risp && \
        if [[ $reboot_risp = "" ]]
        then
                echo $(echo $COLOR_GREEN_LIGHT)$SRAT$(echo $REPLACE) && \
                reboot
        else
                echo $(echo $COLOR_GREEN_LIGHT)$SRMT$(echo $REPLACE) && \
                exit 0
        fi
elif [[ $risp == "N" || $risp == "n" ]]
then
	echo -e $(echo $COLOR_GREEN_LIGT)$STTBC $(echo $REPLACE) 
fi

