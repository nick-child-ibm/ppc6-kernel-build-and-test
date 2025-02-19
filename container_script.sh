#!/bin/bash
config=$1

set -e
ls -la
echo $config
make $config
echo BUILDING NOW
make -j `nproc` binrpm-pkg