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

source /lfs-utils
source /lfs-var
source /lfs-a511
source /language
#language
#set_language


echo $(echo $COLOR_GREEN_LIGHT)"####################"
echo "# Changing ownership"
echo "####################"$(echo $REPLACE)
chown -R 0:0 /tools && \
sleep 1 && \
echo ""

echo $(echo $COLOR_GREEN_LIGHT)"######################"
echo "# Creating directories"
echo "######################"$(echo $REPLACE)
mkdir -p /{bin,boot,dev/{pts,shm},etc/opt,home,lib,mnt,proc}
mkdir -p /{root,sbin,srv,tmp,usr/local,var,opt}
mkdir -p /media/{floppy,cdrom}
mkdir /usr/{bin,include,lib,sbin,share,src}
ln -s share/{man,doc,info} /usr
mkdir /usr/share/{doc,info,locale,man}
mkdir /usr/share/{misc,terminfo,zoneinfo}
mkdir /usr/share/man/man{1,2,3,4,5,6,7,8}
mkdir /usr/local/{bin,etc,include,lib,sbin,share,src}
ln -s share/{man,doc,info} /usr/local
mkdir /usr/local/share/{doc,info,locale,man}
mkdir /usr/local/share/{misc,terminfo,zoneinfo}
mkdir /usr/local/share/man/man{1,2,3,4,5,6,7,8}
mkdir /var/{lock,log,mail,run,spool}
mkdir -p /var/{tmp,opt,cache,lib/misc,local}
mkdir /opt/{bin,doc,include,info}
mkdir -p /opt/{lib,man/man{1,2,3,4,5,6,7,8}}
chmod 0750 /root
chmod 1777 /tmp /var/tmp
sleep 1 && \
echo ""

echo $(echo $COLOR_GREEN_LIGHT)"#############################"
echo "# Creating essential symlinks"
echo "#############################"$(echo $REPLACE)
ln -s /tools/bin/{bash,cat,pwd,stty} /bin
ln -s /tools/bin/perl /usr/bin
ln -s /tools/lib/libgcc_s.so.1 /usr/lib
ln -s bash /bin/sh
sleep 1
echo ""

echo $(echo $COLOR_GREEN_LIGHT)"##########################################"
echo "# Creating the passwd, group and log files"
echo "##########################################"$(echo $REPLACE)
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
EOF

echo ""
echo ""
echo $(echo $COLOR_GREEN_LIGHT)$STTPF$(echo $REPLACE)
echo ""
exec /tools/bin/bash --login +h
