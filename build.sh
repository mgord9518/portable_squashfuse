#!/bin/sh
# Quick script to make portable builds of squashfuse on Ubuntu 18.04
# The libraries I chose to statically link are based on <github.com/AppImage/pkg2appimage/blob/master/excludelist>

[ -z $ARCH ] && ARCH=$(uname -m)

sudo apt install zlib1g-dev liblzma-dev libzstd-dev liblz4-dev make gcc libfuse-dev

git clone https://github.com/vasi/squashfuse
cd squashfuse
mkdir -p static/lib

# Feels hacky, maybe theres a better way to do this? I don't compile very often
ln -s /usr/lib/*/liblz4.a  static/lib
ln -s /usr/lib/*/liblzma.a static/lib
ln -s /usr/lib/*/libzstd.a static/lib

./autogen.sh
./configure --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_$ARCH
mv squashfuse_extract ../squashfuse_extract_$ARCH
mv squashfuse_ll ../squashfuse_ll_$ARCH
mv squashfuse_ls ../squashfuse_ls_$ARCH
