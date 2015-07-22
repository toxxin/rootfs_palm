# Collection of scripts to build rootfs, based on Debian wheezy.

###Tested on Ubuntu 14.04

## Install host packages:
```sh
$ sudo apt-get install multistrap
$ sudo apt-get install qemu
$ sudo apt-get install qemu-user-static
$ sudo apt-get install binfmt-support
$ sudo apt-get install dpkg-cross
```

## Create the root filesystem:
```sh
$ sudo multistrap -a armel -d ./target-rootfs -f multistrap.conf
```

## Configure packages using the armel CPU emulator QEMU:
```sh
$ sudo cp /usr/bin/qemu-arm-static target-rootfs/usr/bin
$ sudo mount -o bind /dev/ target-rootfs/dev/
$ sudo LC_ALL=C LANGUAGE=C LANG=C chroot target-rootfs dpkg --configure -a
```
###*For question:"Use dash as a default system shell (/bin/sh)?", answer NO.*

## Run postscript:
```sh
$ sudo ./postconfig.sh
```

## Set up root password:
```sh
$ sudo chroot target-rootfs passwd
```

## Umount /dev
```sh
$ sudo umount target-rootfs/dev/
```

## Install KDE minimum:
```sh
$ sudo apt-get install kde-plasma-desktop --no-install-recommends
```
