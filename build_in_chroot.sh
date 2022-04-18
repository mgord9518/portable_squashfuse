#!/bin/sh

sudo apt install qemu-user-static

mkdir -p chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd

# Move QEMU to the chroot directory
cp /usr/bin/qemu-aarch64-static upper/usr/bin

# Mount up the chroot
sudo mount -t squashfs "impish-server-cloudimg-$1.squashfs" sfsmnt
sudo mount -t overlay overlay -olowerdir=sfsmnt,upperdir=upper,workdir=work chrootdir

sudo mount -o bind /proc chrootdir/proc/
sudo mount --rbind /run/systemd chrootdir/run/systemd

# --- INSIDE CHROOT ---
cat << EOF | sudo chroot chrootdir /bin/bash
sudo apt update
sudo apt install -y zlib1g-dev liblzma-dev libzstd-dev liblz4-dev make gcc libfuse-dev libfuse3-dev autoconf libtool pkg-config

wget https://raw.githubusercontent.com/mgord9518/portable_squashfuse/main/build-static.sh
sh build-static.sh
EOF
# --- EXIT CHROOT ---

cp chrootdir/squashfuse* ./
sudo umount sfsmnt chrootdir/proc chrootdir/run/systemd chrootdir


exit 0

sudo rm -rf chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd
mkdir -p chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd

 



# Mount up the chroot
sudo mount -t squashfs "bionic-server-cloudimg-$1.squashfs" sfsmnt
sudo mount -t overlay overlay -olowerdir=sfsmnt,upperdir=upper,workdir=work chrootdir

sudo mount -o bind /proc chrootdir/proc/
sudo mount --rbind /run/systemd chrootdir/run/systemd

# --- INSIDE CHROOT ---
cat << EOF | sudo chroot chrootdir /bin/bash
sudo apt update
sudo apt install -y zlib1g-dev liblzma-dev libzstd-dev liblz4-dev make gcc libfuse-dev autoconf libtool pkg-config

wget https://raw.githubusercontent.com/mgord9518/portable_squashfuse/main/build.sh
sh build.sh
EOF
# --- EXIT CHROOT ---
