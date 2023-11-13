#!/bin/sh
# Quick script to make portable builds of squashfuse on Ubuntu

[ -z $ARCH ] && ARCH=$(uname -m)

git clone https://github.com/vasi/squashfuse
cd squashfuse
mkdir -p static/lib

# Feels hacky, maybe theres a better way to do this? I don't compile very often
ln -s /usr/lib/*/liblz4.a  static/lib
ln -s /usr/lib/*/liblzma.a static/lib
ln -s /usr/lib/*/libzstd.a static/lib
ln -s /usr/lib/*/liblzo2.a static/lib

./autogen.sh

# All supported compression methods
CFLAGS="-O3" ./configure --disable-shared --with-lz4=./static --with-xz=./static --with-zstd=./static --with-lzo=./static
make

mv squashfuse ../squashfuse.$ARCH
mv squashfuse_extract ../squashfuse_extract.$ARCH
mv squashfuse_ll ../squashfuse_ll.$ARCH
mv squashfuse_ls ../squashfuse_ls.$ARCH

# ZLIB, LZ4
CFLAGS="-O3" ./configure --disable-shared --with-lz4=./static --without-xz --without-zstd --without-lzo
make

mv squashfuse_ ../squashfuse_lz4.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4.$ARCH

# ZLIB, LZO
CFLAGS="-O3" ./configure --disable-shared --without-lz4 --without-xz --without-zstd --with-lzo=./static
make

mv squashfuse_ ../squashfuse_lz4.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4.$ARCH

# ZLIB, XZ
CFLAGS="-O3" ./configure --disable-shared --without-lz4 --with-xz=./static --without-zstd --without-lzo
make

mv squashfuse_ ../squashfuse_xz.$ARCH
mv squashfuse_extract ../squashfuse_extract_xz.$ARCH
mv squashfuse_ll ../squashfuse_ll_xz.$ARCH
mv squashfuse_ls ../squashfuse_ls_xz.$ARCH


# ZLIB, ZSTD
CFLAGS="-O3" ./configure --disable-shared --without-lz4 --without-xz --with-zstd=./static --without-lzo
make

mv squashfuse_ ../squashfuse_zstd.$ARCH
mv squashfuse_extract ../squashfuse_extract_zstd.$ARCH
mv squashfuse_ll ../squashfuse_ll_zstd.$ARCH
mv squashfuse_ls ../squashfuse_ls_zstd.$ARCH

strip -s ../*.$ARCH
