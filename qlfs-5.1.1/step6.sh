#!/bin/bash
#****************************************************************************
#               QLFS-511-final http://lfs-italia.homelinux.org              #
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
source /tmp/lfs/lfs-a511
#language
#set_language


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
umount /mnt/lfs/dev/pts && \
umount /mnt/lfs/proc && \

echo -e $(echo $COLOR_GREEN_LIGHT)$STTBLS $(echo $REPLACE) && \
read risp
#echo $(echo $COLOR_PURPLE) $STTDP $(echo $REPLACE)
#read path
path=$hdax
dev=$(device "$path")
par=$(partition "$path")

if [[ $risp == "G" || $risp == "g" ]]
then
	echo "" >> /boot/grub/menu.lst && \
	echo "# LFS 5.1.1" >> /boot/grub/menu.lst && \
	echo "title   LFS 5.1.1b, kernel 2.4.26" >> /boot/grub/menu.lst && \
	echo "root    (hd$dev,$par)" >> /boot/grub/menu.lst && \
	echo "kernel  /boot/lfskernel root=$path ro" >> /boot/grub/menu.lst && \
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
	cp /mnt/lfs/boot/lfskernel /boot/lfskernel && \
	umount /mnt/lfs &> /dev/null && \
	echo "" >> /etc/lilo.conf && \
	echo "image=/boot/lfskernel" >> /etc/lilo.conf && \
	echo "label=LFS-511b" >> /etc/lilo.conf && \
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

