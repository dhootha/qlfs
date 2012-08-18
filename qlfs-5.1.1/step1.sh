#!/bin/bash
#****************************************************************************
#               QLFS-511-fianl http://lfs-italia.homelinux.org              #
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
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs-a511
source /tmp/lfs/language

# aggiunta per sicurezza
export LFS=/mnt/lfs

# per versioni di GCC troppo nuove
export CC="gcc -B/usr/bin"

#########################################################
# Controlla la versione della bash
#########################################################
bashver=${BASH_VERSION:0:4}
if [[ $bashver = "3.00" ]]
then 
	gccsed="yes"
else
	gccsed="no"
fi

#########################################################
# Controlla la presenza dei sorgenti di LFS
#########################################################
echo -e $(echo $COLOR_PURPLE)$SDT1 $(echo $REPLACE)
risp="f"
while [[ $risp = "f" ]] ; do
  echo $(echo $COLOR_PURPLE)"[Yes,no]"$(echo $REPLACE)
  risp=$(read_risp)
done

if [[ $risp = "y" ]]
then
	echo $(echo $COLOR_PURPLE)$SDTP $(echo $REPLACE)
        read dir
        while [[ ! -d $dir ]] ; do
        	echo $(echo $COLOR_RED)$SDTF $dir $(echo $REPLACE)
        	echo $(echo $COLOR_PURPLE)$SDTP $(echo $REPLACE)
        	read dir
        done
	
        echo $(echo $COLOR_GREEN_LIGHT)$SDTS $dir $(echo $REPLACE)
	##################################
	# COPIO TUTTI I FILE
	##################################

	
	echo $(echo $COLOR_GREEN_LIGHT)$SCTP $(echo $REPLACE)
	cp -R $dir/* $LFS/sources

else	

	#########################################################
	# Start del download dei pacchetti nella dir $LFS/sources
	#########################################################
	cd $LFS/sources
	
	echo $(echo $COLOR_GREEN_LIGHT)$SDTW $mirror $(echo $REPLACE)

	echo $COLOR_CYAN
	wget $wopt $mirror"lfs-packages-5.1.1.tar" && \
	tar xfv lfs-packages-5.1.1.tar
	$(echo $REPLACE)
	
	echo $(echo $COLOR_GREEN_LIGHT) "##################################"
	echo  $SDTC  
	echo "##################################"$(echo $REPLACE)
fi


	##################################
	# CONTROLLO CON MD5
	##################################
	if [ $md5_sum = "true" ]
	then 
	echo $(echo $COLOR_GREEN_LIGHT)$SDCTK $(echo $REPLACE)

	if md5sum --status --check /tmp/lfs/lfs-511-checksum.md5
	then
		echo $SDCTKK
	else
		echo $SDCTKP
		md5sum --check /tmp/lfs/lfs-511-checksum.md5
		exit $E_MD5SUM
	fi
	fi


echo $(echo $COLOR_GREEN_LIGHT)"##############################################"
$myecho $SDCTSC 
echo "##############################################"$(echo $REPLACE)


 
binutils1_host && \
clear && \
gcc31_host && \
clear && \
linuxheader_host && \
clear && \
glibc_host && \
clear && \
toolchain_host && \
clear && \
tcl_host && \
clear && \
expect_host && \
clear && \
dejagnu_host && \
clear && \
gcc32_host && \
clear && \
binutils2_host && \
clear && \
gawk_host && \
clear && \
coreutils_host && \
clear && \
bzip2_host && \
clear && \
gzip_host && \
clear && \
diffutils_host && \
clear && \
findutils_host && \
clear && \
make_host && \
clear && \
grep_host && \
clear && \
sed_host && \
clear && \
gettext_host && \
clear && \
ncurses_host && \
clear && \
patch_host && \
clear && \
tar_host && \
clear && \
texinfo_host && \
clear && \
bash_host && \
clear && \
utillinux_host && \
clear && \
perl_host && \
clear && \

if [[ $execute_stripping = "true" ]]
then 
	clear && \
	echo $(echo $COLOR_GREEN_LIGHT)"###########" && \
	echo "# Stripping" && \
	echo "###########"$(echo $COLOR_CYAN) && \
	# (opzionale) 
	# Se la partizione LFS e' troppo piccola e' utile rimuovere
	# i simboli di debug dai pacchetti compilati.
	#
	strip --strip-debug /tools/lib/*
 	strip --strip-unneeded /tools/{,s}bin/*
	#
	# E se non bastasse e' possibile rimuovere la documentazione
	#
  	rm -rf /tools/{doc,info,man}
fi

clear && \
echo -e $(echo $COLOR_GREEN_LIGHT)$STTF $(echo $REPLACE) 
exit
