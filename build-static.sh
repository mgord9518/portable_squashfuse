# TODO: clean up this entire script
# MUST be run under Ubuntu 21.04 or newer
# For some reason FUSE3 gets undefined references while static linking otherwise

# All supported compression methods
./configure CFLAGS='-static -Os'
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4_xz_zstd-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz_zstd-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz_zstd-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz_zstd-static.$ARCH

#!/bin/sh

# ZLIB, LZ4 and XZ
./configure CFLAGS='-static -Os' --without-zstd
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4_xz-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4_xz-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4_xz-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4_xz-static.$ARCH

# ZLIB, LZ4
./configure CFLAGS='-static -Os' --without-zstd --without-xz
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_lz4-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_lz4-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_lz4-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_lz4-static.$ARCH

# ZLIB, XZ
./configure CFLAGS='-static -Os' --without-zstd --without-lz4
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_xz-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_xz-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_xz-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_xz-static.$ARCH

# ZLIB, ZSTD
./configure CFLAGS='-static -Os' --without-xz --without-lz4
make LDFLAGS='-all-static'

mv squashfuse ../squashfuse_zstd-static.$ARCH
mv squashfuse_extract ../squashfuse_extract_zstd-static.$ARCH
mv squashfuse_ll ../squashfuse_ll_zstd-static.$ARCH
mv squashfuse_ls ../squashfuse_ls_zstd-static.$ARCH
