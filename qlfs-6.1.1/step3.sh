#!/bin/bash
source /lfs-utils
source /lfs-var
source /lfs61
source /language

#language
#set_language


echo $(echo $COLOR_GREEN_LIGHT)"####################"
echo $CHO
echo "####################"$(echo $REPLACE)
chown -R 0:0 /tools && \
sleep 1 && \
echo ""

echo $(echo $COLOR_GREEN_LIGHT)"######################"
echo $MKD
echo "######################"$(echo $REPLACE)
echo ""
install -d /{bin,boot,dev,etc/opt,home,lib,mnt}
install -d /{sbin,srv,usr/local,var,opt}
install -d /root -m 0750
install -d /tmp /var/tmp -m 1777
install -d /media/{floppy,cdrom}
install -d /usr/{bin,include,lib,sbin,share,src}
ln -s share/{man,doc,info} /usr
install -d /usr/share/{doc,info,locale,man}
install -d /usr/share/{misc,terminfo,zoneinfo}
install -d /usr/share/man/man{1,2,3,4,5,6,7,8}
install -d /usr/local/{bin,etc,include,lib,sbin,share,src}
ln -s share/{man,doc,info} /usr/local
install -d /usr/local/share/{doc,info,locale,man}
install -d /usr/local/share/{misc,terminfo,zoneinfo}
install -d /usr/local/share/man/man{1,2,3,4,5,6,7,8}
install -d /var/{lock,log,mail,run,spool}
install -d /var/{opt,cache,lib/{misc,locate},local}
install -d /opt/{bin,doc,include,info}
install -d /opt/{lib,man/man{1,2,3,4,5,6,7,8}}

echo $(echo $COLOR_GREEN_LIGHT)"#############################"
echo $CSY
echo "#############################"$(echo $REPLACE)
ln -s /tools/bin/{bash,cat,pwd,stty} /bin
ln -s /tools/bin/perl /usr/bin
ln -s /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -s bash /bin/sh
sleep 1
echo ""

echo $(echo $COLOR_GREEN_LIGHT)"##########################################"
echo $PGLF
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
video:x:12:
utmp:x:13:
usb:x:14:
EOF


echo ""
echo ""
echo $(echo $COLOR_GREEN_LIGHT)$STTPF$(echo $REPLACE)
echo ""
exec /tools/bin/bash --login +h
