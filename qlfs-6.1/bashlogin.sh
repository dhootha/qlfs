#!/bin/bash
source /tmp/lfs/lfs-utils
source /tmp/lfs/lfs-var
source /tmp/lfs/language
#set_language
      
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL PATH
EOF

clear
echo -e $(echo $COLOR_GREEN_LIGHT)$mT1 $(echo $REPLACE)

source ~/.bash_profile


