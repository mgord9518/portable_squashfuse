#!/bin/sh

sudo apt install qemu-user-static binfmt-support
sudo update-binfmts --enable qemu-arm
sudo update-binfmts --display qemu-arm
#sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
sudo echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register

wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-arm64.squashfs
mkdir -p chroot/tmp chroot/dev chroot/proc chroot/sys sfsmnt upper/usr/bin work chroot/run/systemd
cp /usr/bin/qemu-aarch64-static upper/usr/bin
sudo mount -t squashfs bionic-server-cloudimg-arm64.squashfs sfsmnt
sudo mount -t overlay overlay -olowerdir=sfsmnt,upperdir=upper,workdir=work chroot

sudo mount -o bind /proc chroot/proc/

sudo mount -t sysfs sys chroot/sys/
sudo mount -o bind /tmp chroot/tmp/
sudo mount -o bind /dev chroot/dev/
sudo mount --rbind /run/systemd chroot/run/systemd
ls

mount
#ls /run
#ls $XDG_RUNTIME_DIR

cat << EOF | sudo chroot chroot /bin/bash
wget https://raw.githubusercontent.com/mgord9518/portable_squashfuse/main/build.sh
sh build.sh
EOF
