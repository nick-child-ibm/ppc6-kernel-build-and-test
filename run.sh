#!/bin/bash

LINUX=/home/nchild/IBM/linux-kernel/net-next
TMPDIR=./linux_tmp
CONFIG=pseries_le_defconfig
# IMAGENAME=fedora-ppc64le-linux
# CONTAINER_SCRIPT=container_script.sh

mkdir $TMPDIR
lndir $LINUX $TMPDIR
set -e
# cp $CONTAINER_SCRIPT $TMPDIR/

# podman build -t $IMAGENAME .
# podman run --platform linux/ppc64le --rm -it --cpus=`nproc` -v $TMPDIR:/`basename $TMPDIR`:z -w /`basename $TMPDIR` \
# 	-v $LINUX:$LINUX:z  localhost/$IMAGENAME bash -c "./container_script.sh $CONFIG"
# much more efficient just to cross compile
pushd $TMPDIR
make ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- -j `nproc` $CONFIG
make ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- -j `nproc` binrpm-pkg
popd