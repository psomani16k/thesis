FROM ubuntu:20.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt install -y \
g++ \
cmake \
ninja-build \
ccache \
libgsl-dev \
libgtk-3-dev \
libboost-dev \
wget \
git \
python3 \
python3-pip \
automake \
bc \
bison \
flex \
gawk \
libc6 \
libc6-dbg \
libdb-dev \
libssl-dev \
libpcap-dev \
vim \
rsync \
gdb \
mercurial \
inden

RUN pip3 install requests distro

# Set up the working directory
WORKDIR /workspace

# Set environment variables for DCE and User Tools
ENV BAKE_HOME=/workspace/bake
ENV PATH="${PATH}:${BAKE_HOME}:${BAKE_HOME}/build/bin"
ENV LD_LIBRARY_PATH="${BAKE_HOME}/build/lib"
ENV DCE_PATH="${BAKE_HOME}/build/bin_dce:${BAKE_HOME}/build/sbin"

# Default command - Start in Fish
CMD ["/bin/bash"]
