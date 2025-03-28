#!/bin/bash

LINUX=/home/nchild/IBM/linux-kernel/net-next
TMPDIR=./linux_tmp
CONFIG=pseries_le_defconfig
NAME=
# IMAGENAME=fedora-ppc64le-linux
# CONTAINER_SCRIPT=container_script.sh


mkdir $TMPDIR
lndir $LINUX $TMPDIR
set -e

# if a kernel name is requested then sub that in, else use the git branch name
if [ -z $NAME ]; then
	pushd $LINUX
	NAME=`git rev-parse --abbrev-ref HEAD`;
	if [[ $NAME =~ "HEAD" ]]; then NAME=`git describe`; fi;
	popd
fi

pushd $TMPDIR
make ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- -j `nproc` $CONFIG
make ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- -j `nproc` binrpm-pkg LOCALVERSION=-$NAME
popd