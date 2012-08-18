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

# Questo file e' lanciato da root
source /tmp/lfs/lfs-utils
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs60
source /tmp/lfs/language
export LFS=/lfs/host

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

