# dependencies of ns3-dce for ns3dce.... just in case
sudo apt install -y g++ cmake ninja-build ccache libgsl-dev libgtk-3-dev libboost-dev wget git python3 python3-pip
sudo apt install -y automake bc bison flex gawk libc6 libc6-dbg libdb-dev libssl-dev libpcap-dev vim rsync gdb
sudo apt install -y mercurial indent libsysfs-dev

sudo apt -y install libncurses-dev

sudo apt install -y graphviz graphviz-dev python3-pygraphviz
pip install pygraphviz

sudo apt install -y qt5-default

# gcc-4.8 is needed on ubuntu 20.04 so....
echo "deb http://in.archive.ubuntu.com/ubuntu bionic main universe" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y gcc-4.8 g++-4.8
head -n -1 /etc/apt/sources.list > temp.txt
sudo mv temp.txt /etc/apt/sources.list
sudo apt update

# setting up the things
rm bakefile.xml
./bake.py configure -e mptcp_thesis
./bake.py check
./bake.py show 
./bake.py download $1

rm ./source/net-next-nuse/arch/lib/defconfig
cp ./mptcp_config ./source/net-next-nuse/arch/lib/defconfig
sed -i 's/git:/https:/' ./source/net-next-nuse/arch/lib/Makefile

./bake.py build $1

git clone https://github.com/psomani16k/mptcp_testing.git ./source/ns-3-dce/myscripts/mptcp
