#!/bin/bash

cd /usr/src && \
wget http://qlfs.spaghettilinux.org/pkg/pkgconfig-0.15.0.tar.gz && \
wget http://qlfs.spaghettilinux.org/pkg/glib-2.6.3.tar.bz2 && \
wget http://qlfs.spaghettilinux.org/pkg/pango-1.8.0.tar.bz2 && \
wget http://qlfs.spaghettilinux.org/pkg/gtk+-2.6.1.tar.bz2 && \
wget http://qlfs.spaghettilinux.org/pkg/atk-1.9.0.tar.bz2 && \

############
# PKGCONFIG
############
cd /usr/src && \
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/X11R6/lib/pkgconfig"
tar xzf pkgconfig-0.15.0.tar.gz
cd pkgconfig-0.15.0 && \
./configure --prefix=/usr && \
make && \
make install && \

#############
# GLIB
#############
cd /usr/src && \
tar xjf glib-2.6.3.tar.bz2 && \
cd glib-2.6.3 && \
./configure --prefix=/usr && \
make && \
make install && \

##############
# PANGO
##############
cd /usr/src && \
tar xjf pango-1.8.0.tar.bz2 && \
cd pango-1.8.0 && \
./configure --prefix=/usr --sysconfdir=/etc && \
make && \
make install && \
touch /etc/pango/pangorc && \

##########
# ATK
##########
cd /usr/src && \
tar xjf atk-1.9.0.tar.bz2 && \
cd atk-1.9.0 && \
./configure --prefix=/usr && \
make && \
make install && \

##########
# GTK
##########
cd /usr/src && \
tar xfj gtk+-2.6.1.tar.bz2 && \
cd gtk+-2.6.1 && \
./configure --prefix=/usr --sysconfdir=/etc \
--without-libtiff --without-libjpeg && \
make && \
make install

