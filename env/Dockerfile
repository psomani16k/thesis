FROM ubuntu:20.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

##################################
#    1. SETTING UP ENV           #
##################################

# 1. Setup Custom Binary Directory
RUN mkdir -p /bins
ENV PATH="/bins:${PATH}"

# 2. Setup Repositories & Install All Dependencies
RUN apt-get update  \
    && apt-get install -y software-properties-common curl \
    && add-apt-repository -y ppa:fish-shell/release-4 \
    && apt-get update \
    && apt-get install -y \
    autoconf \
    automake \
    bc \
    bison \
    build-essential \
    ccache \
    cmake \
    fish \
    flex \
    g++ \
    gawk \
    gdb \
    gettext \
    git \
    indent \
    libboost-dev \
    libc6 \
    libc6-dbg \
    libdb-dev \
    libgsl-dev \
    libgtk-3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    python3-pygraphviz \
    python3-gi-cairo \
    libpcap-dev \
    libssl-dev \
    libsysfs-dev \
    libtool \
    libtool-bin \
    make \
    mercurial \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    rsync \
    unzip \
    vim \
    wget

RUN pip3 install requests distro

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y


##################################
#    2. SETTING UP BAKE          #
##################################

WORKDIR /workspace
RUN git clone https://gitlab.com/nsnam/bake.git ./bake

WORKDIR /workspace/bake
ENV PATH="${PATH}:/workspace/bake/build/bin"
ENV LD_LIBRARY_PATH="/workspace/bake/build/lib"
ENV DCE_PATH="/workspace/bake/build/bin_dce:/workspace/bake/build/sbin"
ENV BAKE_ROOT="/workspace/bake"

##################################
#     3. Create a non-root user  #
##################################

RUN groupadd -r appuser -g 1000 && useradd -r -u 1000 -g appuser appuser \
    && mkdir -p /home/appuser

RUN chown -R appuser:appuser /home/appuser \
    && chown -R appuser:appuser /workspace /bins

# Switch to the non-root user
USER appuser
