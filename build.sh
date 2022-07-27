#!/bin/sh
# Quick script to make portable builds of squashfuse on Ubuntu
# The libraries I chose to statically link are based on <github.com/AppImage/pkg2appimage/blob/master/excludelist>

[ -z $ARCH ] && ARCH=$(uname -m)

git clone https://github.com/vasi/squashfuse
cd squashfuse
mkdir -p static/lib

# Feels hacky, maybe theres a better way to do this? I don't compile very often
ln -s /usr/lib/*/liblz4.a  static/lib
ln -s /usr/lib/*/liblzma.a static/lib
ln -s /usr/lib/*/libzstd.a static/lib

./autogen.sh

move_bins() {
  mv squashfuse ../squashfuse_lz4_xz_zstd.$ARCH
  mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd.$ARCH
  mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd.$ARCH
  mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd.$ARCH
}

# All supported compression methods
CFLAGS="-Os" ./configure --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static
make

move_bins

# ZLIB, LZ4 and XZ
CFLAGS="-Os" ./configure --disable-shared --with-lz4=./static --with-xz=./static --without-zstd
make

move_bins


# ZLIB, LZ4
CFLAGS="-Os" ./configure --disable-shared --with-lz4=./static --without-xz --without-zstd
makeat least one compression library must exist musl linux

move_bins


# ZLIB, XZ
CFLAGS="-Os" ./configure --disable-shared --without-lz4 --with-xz=./static --without-zstd
make

move_bins


# ZLIB, ZSTD
CFLAGS="-Os" ./configure --disable-shared --without-lz4 --without-xz --with-zstd=./static
make

move_bins

strip -s ../*
