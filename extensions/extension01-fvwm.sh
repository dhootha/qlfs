#!/bin/bash

#extension01-fvwm.sh

cd /usr/src && \
wget http://qlfs.spaghettilinux.org/pkg/fvwm-2.5.12.tar.bz2 && \
tar xjf fvwm-2.5.12.tar.bz2 && \
cd fvwm-2.5.12.tar.bz2 && \
./configure --prefix=/usr && \
make && \
make install && \
echo "# fvwm2" >> ~/.xinitrc
