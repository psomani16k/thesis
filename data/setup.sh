#!/bin/bash

git clone https://gitlab.com/nsnam/bake.git ./bake
cd ./bake
git clone https://github.com/psomani16k/bake_mptcp_patch.git ./patch
cd ..

# go to the
cd /workspace/bake

# replace the bakeconf.xml file from bake root
cp ./../patch/bakeconf.xml ./bakeconf.xml

# configure bake and download all the modules
./bake.py configure -e mptcp
./bake.py download -v
./bake.py build -v
