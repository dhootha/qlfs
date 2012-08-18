#!/bin/bash
source /lfs-utils
source /lfs-var
source /lfs61
#source /lfs-var
source /language

#
# Nota:
# Il path all'inizio della compilazione e' quello corretto
#

#language
#set_language

clear && \
file_lfs && \
clear && \
libtool_lfs && \
clear && \
# Se esistono gia' i file bz nella dir /usr/bin , lo script passa subito 
# alla compilazione di sysvinit.
# I force nei link non ci sono in quanto al secondo avvio lo script
# formatta la partizione, quindi non li ho messi.
# Pero attenzione fino a sysvinit se lo script da errore non esce 
# ma riprende la compilazione dal pacchetto sysvinit.
bzip2_lfs && \
clear && \
diffutils_lfs && \
#clear && \
#ed_lfs && \
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
hot_lfs && \
clear && \
man_lfs && \
clear && \
make_lfs && \
clear && \
mod_lfs && \
clear && \
patch_lfs && \
#clear && \
#procinfo_lfs && \
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
udev_lfs && \
clear && \
util_lfs && \
clear && \
openssl_lfs && \
clear && \
wget_lfs && \
clear && \

 #COMPATTAZIONE BINARI E LIBRERIE (FACOLTATIVO)
# fare attenzione, perche e' necessario essere in un 
# ambiente chroot !!! 
if [ $execute_stripping = "true" ]
then 
	clear && \
	echo $(echo $COLOR_GREEN_LIGHT)"###########" && \
	echo $MSTR && \
	echo "###########"$(echo $COLOR_CYAN) && \
	/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
        -exec /tools/bin/strip --strip-debug '{}' ';' 
fi

echo "" && \
echo "" && \
clear && \
echo $(echo $COLOR_GREEN_LIGHT) $EOC $(echo $REPLACE) &&\
sleep 3 && \
clear && \
bootscript_lfs && \
clear && \
scriptclock_lfs && \
clear && \

echo $(echo $COLOR_GREEN_LIGHT)"#############################" && \
echo $CCF && \
echo "#############################"$(echo $COLOR_CYAN) && \
cat >/etc/sysconfig/console <<"EOF"
KEYMAP="us"
FONT="lat9-16 -u iso01"
EOF
#Per controllare i problemi di keymap 
#zgrep '\W14\W' [/percorso/della/vostra/keymap]
# solo con keymap i386)
# Se il tasto 14 e' backspace e non delete :
# La soluzione e' questa: (Decommentare)
#mkdir -p /etc/kbd && cat > /etc/kbd/bs-sends-del <<"EOF"
#                  keycode  14 = Delete Delete Delete Delete
#              alt keycode  14 = Meta_Delete
#        altgr alt keycode  14 = Meta_Delete
#                  keycode 111 = Remove
#    altgr control keycode 111 = Boot
#      control alt keycode 111 = Boot
#altgr control alt keycode 111 = Boot
#EOF
#cat >>/etc/sysconfig/console <<"EOF"
#KEYMAP_CORRECTION="/etc/kbd/bs-sends-del"
#EOF
clear && \
echo $(echo $COLOR_GREEN_LIGHT)"#############################" && \
echo $ICF && \
echo "#############################"$(echo $COLOR_CYAN) && \
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Make sure we don't output everything on the 1 line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On 
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the 
# value contained inside the 1st argument to the 
# readline specific functions

"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF
clear && \

echo $(echo $COLOR_GREEN_LIGHT)"#############################" && \
echo $BCF && \
echo "#############################"$(echo $COLOR_CYAN) && \
cat > /etc/profile << "EOF"
# Begin /etc/profile
export PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
export LC_ALL=en_GB
export LANG=en_GB
export INPUTRC=/etc/inputrc

# End /etc/profile
EOF

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"##################" && \
echo $NCF && \
echo "##################"$(echo $COLOR_CYAN) && \
cd /sources && \
echo "HOSTNAME=lfs" > /etc/sysconfig/network && \
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"##################" && \
echo "# /etc/hosts      " && \
echo "##################"$(echo $COLOR_CYAN) && \
cd /sources && \
cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1  localhost
[192.168.1.1] [<HOSTNAME>.esempio.org] [HOSTNAME]

# End /etc/hosts (network card version)
EOF
# VERSIONE SENZA SCHEDA DI RETE 
#cat > /etc/hosts << "EOF"
# Begin /etc/hosts (no network card version)
#
#127.0.0.1 [<HOSTNAME>.example.org] [HOSTNAME] localhost
#
# End /etc/hosts (no network card version)
#EOF
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"#####################" && \
echo $STTCR && \
echo "#####################"$(echo $COLOR_CYAN) && \
cd /etc/sysconfig/network-devices && \
mkdir ifconfig.eth0 && \
cat > ifconfig.eth0/ipv4 << "EOF"
ONBOOT=yes
SERVICE=ipv4-static
IP=192.168.1.1
GATEWAY=192.168.1.2
PREFIX=24
BROADCAST=192.168.1.255
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain {[Il nome del vostro dominio]}
nameserver [indirizzo IP del nameserver primario]
nameserver [indirizzo IP del nameserver secondario]


# End /etc/resolv.conf
EOF
sleep 2 && \

clear && \
echo $(echo $COLOR_GREEN_LIGHT)"############" && \
echo "# /etc/fstab" && \
echo "############"$(echo $COLOR_CYAN) && \
echo "" && \
#echo $(echo $COLOR_PURPLE)"Inserire la partizione che in cui si e' montato il sistema LFS (/dev/hdaX)"$(echo $REPLACE) && \
#read hdaX
##################################################################
# CONTROLLARE CHE HDAX VENGA PASSATO CORRETTAMENTE NELL'FSTAB!!!!
##################################################################
echo "# Begin /etc/fstab" > /etc/fstab && \
echo "# file system  mount-point  fs-type  options         dump  fsck-order" >> /etc/fstab && \
echo "$hdax     /            $fsformat     defaults        1     1" >> /etc/fstab && \
echo "$swap     swap         swap     pri=1           0     0" >> /etc/fstab && \
echo "proc          /proc        proc     defaults        0     0" >> /etc/fstab && \
echo "sysfs	/sys		sysfs	defaults	0	0" >> /etc/fstab && \
echo "devpts        /dev/pts     devpts   gid=4,mode=620  0     0" >> /etc/fstab && \
echo "shm           /dev/shm     tmpfs    defaults        0     0" >> /etc/fstab && \
echo "# usbfs       /proc/bus/usb  usbfs   devgid=14,devmode=0660         0     0" >> /etc/fstab && \
echo "# End /etc/fstab" >> /etc/fstab && \

sleep 2 && \

echo 6.1.1 > /etc/lfs-release  && \

echo -e $(echo $COLOR_GREEN_LIGHT)$KERNMSG $(echo $REPLACE)
risp="f"
	while [[ $risp = "f" || $risp = "n" ]] ; do
		echo $(echo $COLOR_GREEN_LIGHT) $OKTOCON $(echo $REPLACE)
		risp=$(read_risp)
	done
echo ""$(echo $COLOR_CYAN) 

kernel_lfs

# NECESSARIE!!!!!!
#mkdir /dev/pts 
#mkdir /dev/shm

echo "" && \
echo -e $(echo $COLOR_GREEN_LIGHT)$STTCF $(echo $REPLACE) && \
exit
