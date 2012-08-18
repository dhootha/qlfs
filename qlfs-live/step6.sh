#!/bin/bash
#****************************************************************************
#               QLFS-60alpha http://lfs-italia.homelinux.org                #
#                                                                           #
#      Copyright (C) 2005 Matteo Mattei   matteo.mattei@gmail.com           #
#                         Marco Sciatta   marco.sciatta@gmail.com           #
#                                                                           #
# This program is free software; you can redistribute it and/or modify      #
# it under the terms of the GNU General Public License as published by      #
# the Free Software Foundation; either version 2 of the License, or         #
# (at your option) any later version.                                       #
#                                                                           #
# This program is distributed in the hope that it will be useful,           #
# but WITHOUT ANY WARRANTY; without even the implied warranty of            #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
# GNU General Public License for more details.                              #
#                                                                           #
# You should have received a copy of the GNU General Public License         #
# along with this program; if not, write to the Free Software               #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA #
#                                                                           #
#****************************************************************************

source /tmp/lfs/lfs-utils
source /tmp/lfs/language
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs60

#PER SICUREZZA 
export LFS=/lfs/host

echo $(echo $COLOR_GREEN_LIGHT)"###################################" && \
echo  $STTNRS && \
echo "###################################" && \
echo "" && \
echo $STTWP $(echo $REPLACE) && \
rm -r $LFS/sources && \
rm -r $LFS/tools && \
#rm /tools && \
rm $LFS/*sh && \
rm $LFS/lfs-* && \
rm $LFS/language && \
### UMOUNT 
umount $LFS/dev/pts
umount $LFS/dev/shm
umount $LFS/dev
umount $LFS/proc
umount $LFS/sys

echo -e $(echo $COLOR_GREEN_LIGHT)$STTBLS $(echo $REPLACE) && \
read risp
path=$hdax
dev=$(device "$path")
par=$(partition "$path")

if [[ $risp == "Yes" || $risp == "yes" || $risp == "Y" || $risp == "y" ]]
then
 	echo "default  0" >> $LFS/boot/grub/menu.lst && \
	echo "timeout  30" >> $LFS/boot/grub/menu.lst && \
	echo "color    light-gray/blue yellow/blue" >> $LFS/boot/grub/menu.lst && \
	echo "" >> $LFS/boot/grub/menu.lst && \
 	echo "# (0)    QLFS 6.0" >> $LFS/boot/grub/menu.lst && \
 	echo "title    QLFS 6.0, kernel-2.6.8.1" >> $LFS/boot/grub/menu.lst && \
 	echo "root     (hd$dev,$par)" >> $LFS/boot/grub/menu.lst && \
 	echo "kernel   /boot/lfskernel-2.6.8.1 root=$path ro" >> $LFS/boot/grub/menu.lst && \
 	echo "" && \
	
	cd /
	MBR=${path:0:8}
	grub-install --root-directory=$LFS $MBR
	
 	echo -e $(echo $COLOR_PURPLE)$STTAR $(echo $REPLACE) && \
 	read reboot_risp && \
 	if [[ $reboot_risp = "" ]]
 	then
 		echo $(echo $COLOR_GREEN_LIGHT)$SRAT $(echo $REPLACE) && \
		umount $LFS &> /dev/null && \
 		reboot
 	else
 		echo $(echo $COLOR_GREEN_LIGHT)$SRMT$(echo $REPLACE) && \
 		umount $LFS &> /dev/null && \
 		exit 0
 	fi
else
	echo -e $(echo $COLOR_PURPLE)$STTAR $(echo $REPLACE) && \
        read reboot_risp && \
	if [[ $reboot_risp = "" ]]
	then
		echo $(echo $COLOR_GREEN_LIGHT)$SRAT $(echo $REPLACE) && \
		umount $LFS &> /dev/null && \
		reboot
	else
	        echo $(echo $COLOR_GREEN_LIGHT)$SRMT$(echo $REPLACE) && \
	        umount $LFS &> /dev/null && \
	        exit 0
	fi
fi
