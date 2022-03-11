#!/bin/sh

sudo apt install qemu-system-arm
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-arm64.squashfs
mkdir -p chroot/tmp chroot/dev chroot/proc chroot/sys sfsmnt upper/usr/bin work
cp /usr/bin/qemu-system-arm upper/usr/bin
sudo mount -t squashfs bionic-server-cloudimg-arm64.squashfs sfsmnt
sudo mount -t overlay overlay -olowerdir=sfsmnt,upperdir=upper,workdir=work chroot

sudo mount -o bind /proc chroot/proc/

sudo mount -t sysfs sys chroot/sys/
sudo mount -o bind /tmp chroot/tmp/
sudo mount -o bind /dev chroot/dev/
sudo mount --rbind /run/systemd chroot/run/systemd

cat << EOF | sudo chroot chroot
wget https://raw.githubusercontent.com/mgord9518/portable_squashfuse/main/build.sh
sh build.sh
EOF
