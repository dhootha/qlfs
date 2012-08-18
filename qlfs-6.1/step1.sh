#!/bin/bash

source /tmp/lfs/lfs-utils
source /tmp/lfs/lfs-var
source /tmp/lfs/lfs61
source /tmp/lfs/language

#language
#set_language

# aggiunta per sicurezza
export LFS=/mnt/lfs

# per versioni di GCC troppo nuove
#export CC="gcc -B/usr/bin"

#########################################################
# Controlla la versione della bash
#########################################################
#bashver=${BASH_VERSION:0:4}
#if [[ $bashver = "3.00" ]]
#then 
#	gccsed="yes"
#else
#	gccsed="no"
#fi



#########################################################
# Controlla la presenza dei sorgenti di LFS
#########################################################
echo -e $(echo $COLOR_PURPLE)$SDT1 $VERSION "?"$(echo $REPLACE)
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
#	wget ftp://spaghettilinux.org/spaghettilinux/projects/lfs-italia/pkg/lfs-packages-6.1.tar && \
#	tar xfv lfs-packages-6.1.tar
	wget -r --retr-symlinks -nH -nd ftp://ftp.lfs-matrix.net/pub/lfs/lfs-packages/6.1.1 
#	wget ftp://ftp.gnu.org/gnu/wget/wget-1.9.1.tar.gz
#	wget http://www.openssl.org/source/openssl-0.9.7e.tar.gz
	
	rm MD5SUMS
	$(echo $REPLACE)
	
	echo $(echo $COLOR_GREEN_LIGHT) "##################################"
	echo  $SDTC  
	echo "###########################"$(echo $REPLACE)
fi


	##################################
	# CONTROLLO CON MD5
	##################################
 	if [ $md5_sum = "true" ]
 	then 
 		echo $(echo $COLOR_GREEN_LIGHT)$SDCTK $(echo $REPLACE)
 
		if md5sum --status --check /tmp/lfs/lfs-61-checksum.md5
		then
			echo $SDCTKK
 		else
 			echo $SDCTKP
 			md5sum --check /tmp/lfs/lfs-61-checksum.md5
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
linux_libc_headers_host && \
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
# RISETTO CC
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
m4_host && \
clear && \
bison_host && \
clear && \
flex_host && \
clear && \
utillinux_host && \
clear && \
perl_host && \
clear && \
#udev_host && \
clear && \

if [[ $execute_stripping = "true" ]]
then 
	clear && \
	echo $(echo $COLOR_GREEN_LIGHT)"###########" && \
	echo $MSTR && \
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
