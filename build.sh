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

# All supported compression methods
./configure --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_lz4_xz_zstd.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd.$ARCH

# ZLIB, LZ4 and XZ
./configure --disable-shared --with-lz4=./static --with-xz=./static --without-zstd
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_lz4_xz.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz.$ARCH

# ZLIB, LZ4
./configure --disable-shared --with-lz4=./static --without-xz --without-zstd
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_lz4.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4.$ARCH

# ZLIB, XZ
./configure --disable-shared --without-lz4 --with-xz=./static --without-zstd
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_xz.$ARCH
mv squashfuse_extract ../squashfuse_extract_xz.$ARCH
mv squashfuse_ll ../squashfuse_ll_xz.$ARCH
mv squashfuse_ls ../squashfuse_ls_xz.$ARCH

# ZLIB, ZSTD
./configure --disable-shared --without-lz4 --without-xz --with-zstd=./static
make

strip -s squashfuse squashfuse_extract squashfuse_ll squashfuse_ls
mv squashfuse ../squashfuse_zstd.$ARCH
mv squashfuse_extract ../squashfuse_extract_zstd.$ARCH
mv squashfuse_ll ../squashfuse_ll_zstd.$ARCH
mv squashfuse_ls ../squashfuse_ls_zstd.$ARCH
