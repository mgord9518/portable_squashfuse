#!/bin/sh
# Quick script to make portable builds of squashfuse on Ubuntu 18.04
# The libraries I chose to statically link are based on <github.com/AppImage/pkg2appimage/blob/master/excludelist>

[ -z $ARCH ] && ARCH=$(uname -m)

# Add AARCH64 arch
sudo dpkg --add-architecture arm64

echo 'deb [arch=arm64] http://ports.ubuntu.com/ bionic main restricted
deb [arch=arm64] http://ports.ubuntu.com/ bionic-updates main restricted
deb [arch=arm64] http://ports.ubuntu.com/ bionic universe
deb [arch=arm64] http://ports.ubuntu.com/ bionic-updates universe
deb [arch=arm64] http://ports.ubuntu.com/ bionic multiverse
deb [arch=arm64] http://ports.ubuntu.com/ bionic-updates multiverse
deb [arch=arm64] http://ports.ubuntu.com/ bionic-backports main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list.d/arm-cross-compile-sources.list

sudo sed -i 's/deb/deb [arch=amd64]/g' /etc/apt/sources.list

sudo apt update
sudo apt install zlib1g-dev liblzma-dev libzstd-dev liblz4-dev make gcc libfuse-dev 
git clone https://github.com/vasi/squashfuse
cd squashfuse
mkdir -p static/lib

# Feels hacky, maybe theres a better way to do this? I don't compile very often
ln -s /usr/lib/*/liblz4.a  static/lib
ln -s /usr/lib/*/liblzma.a static/lib
ln -s /usr/lib/*/libzstd.a static/lib

./autogen.sh

# All supported compression methods
./configure --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_lz4_xz_zstd.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd.$ARCH

sudo apt remove zlib1g-dev liblzma-dev libzstd-dev liblz4-dev gcc libfuse-dev 
sudo apt install zlib1g-dev:arm64 liblzma-dev:arm64 libzstd-dev:arm64 liblz4-dev:arm64 libfuse-dev:arm64 gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi

# Compile for AARCH64
rm static/lib/*
ln -s /usr/lib/*/liblz4.a  static/lib
ln -s /usr/lib/*/liblzma.a static/lib
ln -s /usr/lib/*/libzstd.a static/lib

export ARCH=aarch64
./configure CC=arm-linux-gnueabi-gcc --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_lz4_xz_zstd.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd.$ARCH
## ZLIB, LZ4 and XZ
#./configure --disable-shared --with-lz4=./static --with-xz=./static --without-zstd
#make
#
#strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
#mv squashfuse ../squashfuse_lz4_xz.$ARCH
#mv squashfuse_extract ../squashfuse_extract_lz4_xz.$ARCH
#mv squashfuse_ll ../squashfuse_ll_lz4_xz.$ARCH
#mv squashfuse_ls ../squashfuse_ls_lz4_xz.$ARCH
#
## ZLIB, LZ4
#./configure --disable-shared --with-lz4=./static --without-xz --without-zstd
#make
#
#strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
#mv squashfuse ../squashfuse_lz4.$ARCH
#mv squashfuse_extract ../squashfuse_extract_lz4.$ARCH
#mv squashfuse_ll ../squashfuse_ll_lz4.$ARCH
#mv squashfuse_ls ../squashfuse_ls_lz4.$ARCH
#
## ZLIB, XZ
#./configure --disable-shared --without-lz4 --with-xz=./static --without-zstd
#make
#
#strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
#mv squashfuse ../squashfuse_xz.$ARCH
#mv squashfuse_extract ../squashfuse_extract_xz.$ARCH
#mv squashfuse_ll ../squashfuse_ll_xz.$ARCH
#mv squashfuse_ls ../squashfuse_ls_xz.$ARCH
#
## ZLIB, ZSTD
#./configure --disable-shared --without-lz4 --without-xz --with-zstd=./static
#make
#
#strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
#mv squashfuse ../squashfuse_zstd.$ARCH
#mv squashfuse_extract ../squashfuse_extract_zstd.$ARCH
#mv squashfuse_ll ../squashfuse_ll_zstd.$ARCH
#mv squashfuse_ls ../squashfuse_ls_zstd.$ARCH
