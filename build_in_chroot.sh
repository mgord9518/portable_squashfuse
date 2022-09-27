#!/bin/sh

sudo apt install qemu-user-static

mkdir $1 && cd $1

mkdir -p chrootdir1/tmp chrootdir1/dev chrootdir1/proc sfsmnt1 upper1/usr/bin work1 upper1/run/systemd

# Move QEMU to the chroot directory
cp /usr/bin/qemu-aarch64-static upper1/usr/bin

# Mount up the chroot
sudo mount -t squashfs ../"jammy-server-cloudimg-$1.squashfs" sfsmnt1
sudo mount -t overlay overlay -olowerdir=sfsmnt1,upperdir=upper1,workdir=work1 chrootdir1

sudo mount -o bind /proc chrootdir1/proc/
sudo mount --rbind /run/systemd chrootdir1/run/systemd

# --- INSIDE CHROOT ---
cat << EOF | sudo chroot chrootdir1 /bin/bash
sudo apt update
sudo apt install -y zlib1g-dev liblzma-dev libzstd-dev liblz4-dev make gcc libfuse-dev libfuse3-dev autoconf libtool pkg-config

wget https://raw.githubusercontent.com/mgord9518/portable_squashfuse/main/build-static.sh
sh build-static.sh
EOF
# --- EXIT CHROOT ---

cp chrootdir1/squashfuse* ../
#sudo umount sfsmnt chrootdir/proc chrootdir/run/systemd chrootdir
#mount

#exit 0

#sudo rm -rf chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd
mkdir -p chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd

 



# Mount up the chroot
sudo mount -t squashfs ../"bionic-server-cloudimg-$1.squashfs" sfsmnt
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

cp chrootdir/squashfuse* ../
exit 0
#sudo umount sfsmnt chrootdir/proc chrootdir/run/systemd chrootdir
#sudo rm -rf chrootdir/tmp chrootdir/dev chrootdir/proc sfsmnt upper/usr/bin work upper/run/systemd
