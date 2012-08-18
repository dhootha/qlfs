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

clear && \
file_lfs && \
clear && \
libtool_lfs && \
clear && \
# Se esistono gia' i file bz2 nella dir /usr/bin , lo script passa subito 
# alla compilazione di sysvinit.
# I force nei link non ci sono in quanto al secondo avvio lo script
# formatta la partizione, quindi non li ho messi.
# Pero attenzione fino a sysvinit se lo script da errore non esce 
# ma riprende la compilazione dal pacchetto sysvinit.
bzip2_lfs && \
clear && \
diffutils_lfs && \
clear && \
ed_lfs && \
clear && \
kbd_lfs && \
clear && \
e2fs_lfs && \
clear && \
grep_lfs && \
clear && \
grub_lfs && \
clear && \
gzip2_lfs && \
clear && \
man_lfs && \
clear && \
make_lfs && \
clear && \
mod_lfs && \
clear && \
patch_lfs && \
clear && \
procinfo_lfs && \
clear && \
proc_lfs && \
clear && \
psmisc_lfs && \
clear && \
shadow_lfs && \
clear && \
syslo_lfs && \
clear && \
sysvinit_lfs && \
clear && \
tar_lfs && \

clear && \
util_lfs && \
clear && \
gcc2_lfs  && \
#COMPATTAZIONE BINARI E LIBRERIE (FACOLTATIVO)

if [ $execute_stripping = "true" ]
then 
	clear && \
	echo $(echo $COLOR_GREEN_LIGHT)"###########" && \
	echo "# Stripping" && \
	echo "###########"$(echo $COLOR_CYAN) && \
	/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
        -exec /tools/bin/strip --strip-debug '{}' ';' 
fi

echo "" && \
echo "" && \
clear && \
echo $(echo $COLOR_GREEN_LIGHT)"HAI FINITO IL CAPITOLO 6..."$(echo $REPLACE) &&\
sleep 3 && \
clear && \
bootscript_lfs && \
clear && \
scriptclock_lfs && \
clear && \
echo $(echo $COLOR_GREEN_LIGHT)"##################" && \
echo "# Script Localnet " && \
echo "##################"$(echo $COLOR_CYAN) && \
cd /sources && \
echo "HOSTNAME=lfs" > /etc/sysconfig/network && \
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"##################" && \
echo "# /etc/hosts      " && \
echo "##################"$(echo $COLOR_CYAN) && \
cd /sources && \
cat > /etc/hosts.no-net << "EOF"
# Begin /etc/hosts (versione senza scheda di rete)

127.0.0.1 <valore dell'HOSTNAME>.example.org <valore dell'HOSTNAME> localhost

# End /etc/hosts (versione senza scheda di rete)
EOF

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (versione con scheda di rete)

127.0.0.1 localhost
192.168.1.2 <valore dell'HOSTNAME>.example.org <valore dell'HOSTNAME>

# End /etc/hosts (versione con scheda di rete)
EOF
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"#####################" && \
echo $STTCR && \
echo "#####################"$(echo $COLOR_CYAN) && \
cat >> /etc/sysconfig/network << "EOF"
GATEWAY=192.168.1.1
GATEWAY_IF=eth0
EOF

cat > /etc/sysconfig/network-devices/ifconfig.eth0 << "EOF"
ONBOOT=yes
SERVICE=static
IP=192.168.1.2
NETMASK=255.255.255.0
BROADCAST=192.168.1.255
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver <indirizzo IP del vostro nameserver>

# End /etc/resolv.conf
EOF
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"############" && \
echo "# /etc/fstab" && \
echo "############"$(echo $COLOR_CYAN) && \
echo "" && \
##################################################################
# CONTROLLARE CHE HDAX VENGA PASSATO CORRETTAMENTE NELL'FSTAB!!!!
##################################################################
echo "# Begin /etc/fstab" > /etc/fstab && \
echo "# file system  mount-point  fs-type  options         dump  fsck-order" >> /etc/fstab && \
echo "$hdax     /            $fsformat     defaults        1     1" >> /etc/fstab && \
echo "$swap     swap         swap     pri=1           0     0" >> /etc/fstab && \
echo "proc          /proc        proc     defaults        0     0" >> /etc/fstab && \
echo "devpts        /dev/pts     devpts   gid=4,mode=620  0     0" >> /etc/fstab && \
echo "shm           /dev/shm     tmpfs    defaults        0     0" >> /etc/fstab && \
echo "# usbfs       /proc/bus/usb  usbfs    defaults        0     0" >> /etc/fstab && \
echo "# End /etc/fstab" >> /etc/fstab && \

sleep 2 && \

kernel_lfs

##################################################################
###### FUNZIONE PER CREARE IL DEVICE #############################
##################################################################
partizione=$hdax
check_device $partizione

if [[ $swap != "" && $swap != "'# shared'" ]]
then 
	partizione=$swap
	check_device $partizione
fi

##################################################################
echo "" && \
echo -e $(echo $COLOR_GREEN_LIGHT)$STTCF $(echo $REPLACE) && \
exit
