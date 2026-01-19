#!/bin/bash

git clone https://gitlab.com/nsnam/bake.git ./bake
cd ./bake
git clone https://github.com/psomani16k/bake_mptcp_patch.git ./patch
cd ..

# go to the
cd $BAKE_ROOT

# replace the bakeconf.xml file from bake root
cp ./patch/bakeconf.xml ./bakeconf.xml

# configure bake and download all the modules
./bake.py configure -e mptcp
./bake.py download -v

# copy the net-next-nuse-mptcp patchs
cp ./patch/compiler-gcc.h ./source/net-next-nuse-mptcp/include/linux/compiler-gcc.h
cp ./patch/Makefile ./source/net-next-nuse-mptcp/arch/lib/Makefile

./bake.py build -v
