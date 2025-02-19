#!/bin/bash
# this script, starts qemu with a kernel and build an externalized module for some reason

SHARED_DIR=`pwd`/test
LINUX_DIR=`pwd`/linux_tmp
VMLINUX=$LINUX_DIR/vmlinux
set -e 
pushd $SHARED_DIR; make KERN_BUILD=$LINUX_DIR; popd

cat >test.expect <<EOL
#!/usr/bin/expect -f
spawn qemu-system-ppc64 -nographic  -kernel $VMLINUX \
	-initrd /home/nchild/IBM/linux-kernel/mpe_build/ci-scripts/root-disks/ppc64le-rootfs.cpio.gz \
	-m 512 -machine pseries,usb=off -nic user,model=virtio-net-pci \
	-virtfs local,path=$SHARED_DIR,mount_tag=host0,security_model=passthrough,id=host0 \
	--append "noreboot"  -vga none
expect "Boot successful."
expect "/ # "
send -- "echo 'host0   /foo    9p  trans=virtio,version=9p2000.L   0   0' >> /etc/fstab &&  mkdir foo && mount -a\r"
expect "/ # "

send -- "insmod /foo/new_mod.ko;\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=2\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=4\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=3\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=5\r"
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=8\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko groupsize=16\r"
expect "/ # "
send -- "rmmod new_mod; insmod /foo/new_mod.ko buflen=2\r"

interact
EOL

chmod +x test.expect
sudo ./test.expect