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

touch /var/run/utmp /var/log/{btmp,lastlog,wtmp} && \
chmod 644 /var/run/utmp /var/log/{btmp,lastlog,wtmp} && \

echo $(echo $COLOR_GREEN_LIGHT)$STTWDC $(echo $REPLACE)
for file in $(ls /sources); do
	if [ -d /sources/$file -a $file != "binutils-build" -a $file != "binutils-2.14" ]
	then
		rm -rf /sources/$file
        fi
done && \

echo ""
makedev_lfs && \
clear && \
headers_lfs && \
clear && \
manpage_lfs && \
clear && \
glibc_lfs && \
echo ""
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

cp --remove-destination /usr/share/zoneinfo/Europe/Rome /etc/localtime && \

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

# End /etc/ld.so.conf
EOF

clear && \
toolchain_lfs && \
clear && \
binutils_lfs && \
clear && \
gcc_lfs && \
clear && \
coreutils_lfs && \
clear && \
zlib_lfs && \
clear && \
mktemp_lfs && \
clear && \
iana_lfs && \
clear && \
findutils_lfs && \
clear && \
gawk_lfs && \
clear && \
ncurses_lfs && \
clear && \
vim_lfs && \
clear && \
m4_lfs && \
clear && \
bison_lfs && \
clear && \
less_lfs && \
clear && \
groff_lfs && \
clear && \
sed_lfs && \
clear && \
flex_lfs && \
clear && \
gettext_lfs && \
clear && \
net_lfs && \
clear && \
inetutils_lfs && \
clear && \
perl_lfs && \
clear && \
texinfo_lfs && \
clear && \
autoconf_lfs && \
clear && \
automake_lfs && \
clear && \
bash_lfs && \
clear && \
cd / 

echo $(echo $COLOR_GREEN_LIGHT)$STTFF$(echo $REPLACE)
echo ""
exec /bin/bash --login +h
