#!/bin/bash
source /lfs-utils
source /lfs-var
source /lfs61
source /language

#language
#set_language

touch /var/run/utmp /var/log/{btmp,lastlog,wtmp} && \
chgrp utmp /var/run/utmp /var/log/lastlog && \
chmod 664 /var/run/utmp /var/log/lastlog && \

echo $(echo $COLOR_GREEN_LIGHT)$STTWDC $(echo $REPLACE)
for file in $(ls /sources); do
	if [ -d /sources/$file -a $file != "binutils-build" -a $file != "binutils-2.15.94.0.2.2" ]
	then
		rm -rf /sources/$file
        fi
done && \

echo ""
echo "###################################"
echo $MKDE  
echo "###################################"
mknod -m 600 /dev/console c 5 1 
mknod -m 666 /dev/null c 1 3
mount -n -t tmpfs none /dev && \

mknod -m 622 /dev/console c 5 1 
mknod -m 666 /dev/null c 1 3
mknod -m 666 /dev/zero c 1 5
mknod -m 666 /dev/ptmx c 5 2
mknod -m 666 /dev/tty c 5 0
mknod -m 444 /dev/random c 1 8
mknod -m 444 /dev/urandom c 1 9
chown root:tty /dev/{console,ptmx,tty}

ln -s /proc/self/fd /dev/fd && \
ln -s /proc/self/fd/0 /dev/stdin && \
ln -s /proc/self/fd/1 /dev/stdout && \
ln -s /proc/self/fd/2 /dev/stderr && \
ln -s /proc/kcore /dev/core && \
mkdir /dev/pts && \
mkdir /dev/shm && \
mount -t devpts -o gid=4,mode=620 none /dev/pts &> /dev/null && \
mount -t tmpfs none /dev/shm &> /dev/null && \

clear && \
linux_libc_headers_lfs && \
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
readline_lfs && \
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
#net_lfs && \
#clear && \
inetutils_lfs && \
clear && \
iproute_lfs && \
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
