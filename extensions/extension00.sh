#!/bin/bash
clear
echo "####################################################"
echo "# EXTENSION 00 - XORG CON FVWM 			 #"
echo "# 						 #"
echo "# Programmi installati : 				 #"
echo "#				Xorg 6.8.2		 #"
echo "# Dipendenze installate: 				 #"
echo "# 			Libpng-1.2.8		 #"
echo "#				Fontconfig-2.2.3	 #"
echo "#				|-> FreeType-2.19        #"
echo "#				|-> expat-1.95.8	 #"
#echo "#				Linux-Pam-0.78		 #"
echo "#						 	 #"
echo "#						         #"
echo "####################################################"
sleep 3

cd /usr/src && \

echo "Download del pacchetto Libpng-1.2.8 ..." && \
wget http://qlfs.spaghettilinux.org/pkg/libpng-1.2.8.tar.bz2 && \
wget http://qlfs.spaghettilinux.org/pkg/libpng-1.2.8-link_to_proper_libs-1.patch && \
echo "" && \
echo "Download del pacchetto Fontconfig-2.2.3 ..." && \
wget http://qlfs.spaghettilinux.org/pkg/fontconfig-2.2.3.tar.gz && \
echo "" && \
echo "Download del pacchetto FreeType-2.19 ..." && \
wget http://qlfs.spaghettilinux.org/pkg/freetype-2.1.9.tar.gz && \
wget http://qlfs.spaghettilinux.org/pkg/freetype-2.1.9-bytecode_interpreter-1.patch && \
echo "" && \
echo "Download del pacchetto expat-1.95.8 ..." && \
wget http://qlfs.spaghettilinux.org/pkg/expat-1.95.8.tar.gz && \
#echo "" && \
#echo "Download del pacchetto Linux-PAM-0.78 ..." && \
#wget  ftp://ftp.kernel.org/pub/linux/libs/pam/pre/library/Linux-PAM-0.78.tar.bz2 && \
#wget http://www.linuxfromscratch.org/blfs/downloads/6.0/Linux-PAM-0.78-linkage-2.patch && \
echo "" && \
echo "Download del pacchetto Xorg 6.8.2 ..." && \
wget http://qlfs.spaghettilinux.org/pkg/X11R6.8.2-src.tar.bz2 && \

clear && \

echo "###################################################" && \
echo "# 	INIZIO COMPILAZIONE			#" && \
echo "###################################################" && \
echo "" && \
cd /usr/src && \

echo "###################" && \
echo "# libpng-1.2.8	#" && \
echo "###################" && \
tar xjf libpng-1.2.8.tar.bz2 && \
cd libpng-1.2.8 && \
patch -Np1 -i ../libpng-1.2.8-link_to_proper_libs-1.patch && \
make prefix=/usr ZLIBINC=/usr/include \
    ZLIBLIB=/usr/lib -f scripts/makefile.linux && \
make prefix=/usr install -f scripts/makefile.linux && \
ldconfig && \
clear && \

echo "##################" && \
echo "# FreeType-2.19  #" && \
echo "##################" && \
cd /usr/src && \
tar xzf freetype-2.1.9.tar.gz && \
cd freetype-2.1.9 && \
patch -Np1 -i ../freetype-2.1.9-bytecode_interpreter-1.patch && \
./configure --prefix=/usr && \
make && \
make install && \
clear && \

echo "##################" && \
echo "# expat-1.95.8   #" && \
echo "##################" && \
cd /usr/src && \
tar xzf expat-1.95.8.tar.gz && \
cd expat-1.95.8 && \
./configure --prefix=/usr && \
make && \
make install && \
clear && \

echo "####################" && \
echo "# fontconfig-2.2.3 #" && \
echo "####################" && \
cd /usr/src && \
tar xzf fontconfig-2.2.3.tar.gz && \
cd fontconfig-2.2.3 && \
./configure --prefix=/usr \
    --sysconfdir=/etc --disable-docs && \
make && \
make install && \
#sed -i.orig \
#    -e "/CATALOG \/etc\/sgml\/OpenSP-1.5.1.cat/d" \
#    /etc/sgml/catalog \
#    /etc/sgml/sgml-docbook.c
clear && \

echo "####################" && \
echo "#  Xorg 6.8.2	 #" && \
echo "####################" && \
cd /usr/src && \
tar xjf X11R6.8.2-src.tar.bz2 && \
cd xc && \
sed -i '/^SUBDIRS =/s/ etc$//' programs/Xserver/Xprint/Imakefile && \
pushd config/util &&
make -f Makefile.ini lndir && \
cp lndir /usr/bin/ && \
#DA USER!!?! 
popd && \
mkdir ../xcbuild && \
cd ../xcbuild && \
lndir ../xc && \
cat > config/cf/host.def << "EOF"
/* Begin Xorg host.def file */
 
/* System Related Information.  If you read and configure only one
 * section then it should be this one.  The Intel architecture defaults 
 * are set for a i686 and higher.  Axp is for the Alpha architecture 
 * and Ppc is for the Power PC.  AMD64 is for the Opteron processor. 
 * Note that there have been reports that the Ppc optimization line 
 * causes segmentation faults during build.  If that happens, try 
 * building without the DefaultGcc2PpcOpt line.  ***********/
 
/* #define DefaultGcc2i386Opt -O2 -fno-strength-reduce \
                              -fno-strict-aliasing -march=i686 */
/* #define DefaultGccAMD64Opt -O2 -fno-strength-reduce \
                              -fno-strict-aliasing */
/* #define DefaultGcc2AxpOpt  -O2 -mcpu=ev6 */
/* #define DefaultGcc2PpcOpt  -O2 -mcpu=750 */

#define HasFreetype2            YES
#define HasFontconfig           YES
#define HasExpat                YES
#define HasLibpng               YES
#define HasZlib                 YES

/*
 * Which drivers to build.  When building a static server, each of 
 * these will be included in it.  When building the loadable server 
 * each of these modules will be built.
 *
#define XF86CardDrivers         mga glint nv tga s3virge sis rendition \
                                neomagic i740 tdfx savage \
                                cirrus vmware tseng trident chips apm \
                                GlideDriver fbdev i128 \
                                ati AgpGartDrivers DevelDrivers ark \
                                cyrix siliconmotion vesa vga \
                                XF86OSCardDrivers XF86ExtraCardDrivers
*/

/*
 * Select the XInput devices you want by uncommenting this.
 *
#define XInputDrivers           mouse keyboard acecad calcomp citron \
                                digitaledge dmc dynapro elographics \
                                microtouch mutouch penmount spaceorb \
                                summa wacom void magictouch aiptek
 */

/* Most installs will only need this */

#define XInputDrivers           mouse keyboard

/* Disable building Xprint server and clients until we get them figured
 * out but build Xprint libraries to allow precompiled binaries such as
 * Acrobat Reader to run.
 */

#define XprtServer              NO
#define BuildXprintClients      NO

/* End Xorg host.def file */
EOF

sed -i -e "s@^#include <linux/config.h>@/* & */@" \
    `grep -lr linux/config.h *` &&
( make World 2>&1 | tee xorg-compile.log && exit $PIPESTATUS )

make install && \
make install.man && \
ln -sf ../X11R6/bin /usr/bin/X11 && \
ln -sf ../X11R6/lib/X11 /usr/lib/X11 && \
ln -sf ../X11R6/include/X11 /usr/include/X11 && \
echo "Aggiornamento del sistema..."
ldconfig && \
#cd ~
#Xorg -configure
#X -config ~/xorg.conf.new
#mv ~/xorg.conf.new /etc/X11/xorg.conf
cat > ~/.xinitrc << "EOF"
# Begin .xinitrc file
xterm  -g 80x40+0+0   &
xclock -g 100x100-0+0 &
twm
EOF
cat >> /etc/sysconfig/createfiles << "EOF"
/tmp/.ICE-unix dir 1777 root root
EOF

# SISTEMAZIONE DEI PATH
echo "/usr/X11R6/lib" >> /etc/ld.so.conf
echo "export PATH=$PATH:/usr/bin/X11" >> /etc/profile
ldconfig

#startx
clear && \
echo "Installazione completata."
echo "E' necessario ora creare il file di configurazione per Xorg"
echo "tramite il comando Xorg -configure"
echo "Per testare la configurazione lanciare X -config ~/xorg.conf.new"
echo "se tutto e' stato configurato salvare il file come /etc/X11/xorg.conf"
echo "e lanciare Xorg con startx"
echo ""
echo ""
source /etc/profile