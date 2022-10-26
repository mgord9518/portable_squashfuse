#!/bin/sh
# Static build script designed for Alpine

[ -z $ARCH ] && ARCH=$(uname -m)

git clone https://github.com/vasi/squashfuse
cd squashfuse

./autogen.sh

export CFLAGS='-static -Os'

# All supported compression methods
./configure
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4_xz_zstd-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd-static.$ARCH

# ZLIB, LZ4 and XZ
./configure --without-zstd
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4_xz-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz-static.$ARCH

# ZLIB, LZ4
./configure --without-zstd --without-xz
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4-static.$ARCH

# ZLIB, XZ
./configure --without-zstd --without-lz4
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_xz-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_xz-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_xz-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_xz-static.$ARCH

# ZLIB, ZSTD
./configure --without-xz --without-lz4
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_zstd-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_zstd-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_zstd-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_zstd-static.$ARCH

# Create static library
perl -0pe "s/int main/int squashfuse_main/"
./configure
make LDFLAGS='-all-static'
ar -rcs ../libsquashfuse_hl-$ARCH.a squashfuse-hl.o libsquashfuse_convenience_la-*.o libfuseprivate_la-*.o 

