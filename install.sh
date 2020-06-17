#!/bin/sh
cd /media/root/ROOTFS/
sudo rm -rf *
wget http://vault.centos.org/altarch/7.4.1708/isos/aarch64/CentOS-7-aarch64-rootfs-7.4.1708.tar.xz
tar --numeric-owner -xpf CentOS-7-aarch64-rootfs-7.4.1708.tar.xz
sudo rm -rf /media/root/ROOTFS/lib/modules/* /media/root/ROOTFS/lib/firmware/* /media/root/ROOTFS/boot/*
cp -rp /boot/* /media/root/ROOTFS/boot
cp -rp /lib/modules/* /media/root/ROOTFS/lib/modules
cp -rp /lib/firmware/* /media/root/ROOTFS/lib/firmware
sudo mv /media/root/ROOTFS/lib/firmware/brcm/brcmfmac4330-sdio.txt /media/root/ROOTFS/lib/firmware/brcm/brcmfmac4330-sdio.txt.old
sudo ln -s  /media/root/ROOTFS/lib/firmware/brcm/brcmfmac-ap6330-sdio.txt /media/root/ROOTFS/lib/firmware/brcm/brcmfmac4330-sdio.txt
sudo blkid --label ROOTFS
sudo blkid -s UUID -o value /dev/mmcblk0p2
echo "UID=0ee128bf-93c3-4f3c-8b57-03cfa7a12cfd  /  ext4  defaults  0  0" > /media/root/ROOTFS/etc/fstab