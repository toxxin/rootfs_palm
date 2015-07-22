#!/bin/sh
#Directory contains the target rootfs
TARGET_ROOTFS_DIR="target-rootfs"

#Directory used to mount the data partition 
mkdir $TARGET_ROOTFS_DIR/media/data

#Board hostname
filename=$TARGET_ROOTFS_DIR/etc/hostname
echo nmv > $filename

#Default name servers
filename=$TARGET_ROOTFS_DIR/etc/resolv.conf
echo nameserver 8.8.8.8 > $filename
echo nameserver 8.8.4.4 >> $filename

#Default network interfaces
filename=$TARGET_ROOTFS_DIR/etc/network/interfaces
echo auto lo > $filename
echo iface lo inet loopback >> $filename
echo allow-hotplug eth0 >> $filename
echo iface eth0 inet dhcp >> $filename
#eth0 MAC address
echo hwaddress ether 00:04:25:12:34:56 >> $filename

#Set the the debug port
filename=$TARGET_ROOTFS_DIR/etc/inittab
echo 7:23:respawn:/sbin/getty -L ttyO2 115200 vt100 >> $filename

#Default localhost name
filename=$TARGET_ROOTFS_DIR/etc/hosts
# add 127.0.0.1 boardname

#Set rules to change wlan dongles
#filename=$TARGET_ROOTFS_DIR/etc/udev/rules.d/70-persistent-net.rules
#echo SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="*", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wlan*", NAME="wlan0" > $filename

#microSD partitions mounting
filename=$TARGET_ROOTFS_DIR/etc/fstab
echo /dev/mmcblk0p1 /boot vfat noatime 0 1 > $filename
echo /dev/mmcblk0p2 / ext4 noatime 0 1 >> $filename
echo proc /proc proc defaults 0 0 >> $filename

#Add the standard Debian non-free repositories useful to load
#closed source firmware (i.e. WiFi dongle firmware)
filename=$TARGET_ROOTFS_DIR/etc/apt/sources.list
echo deb http://http.debian.net/debian/ wheezy main contrib non-free > $filename

echo "Update packages"
LC_ALL=C LANGUAGE=C LANG=C chroot $TARGET_ROOTFS_DIR apt-get update
LC_ALL=C LANGUAGE=C LANG=C chroot $TARGET_ROOTFS_DIR apt-get upgrade
LC_ALL=C LANGUAGE=C LANG=C chroot $TARGET_ROOTFS_DIR apt-get clean

echo "Remove Qemu..."
rm $TARGET_ROOTFS_DIR/usr/bin/qemu-arm-static
