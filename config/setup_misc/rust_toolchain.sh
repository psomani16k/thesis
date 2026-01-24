#!/bin/bash

# Install rust
echo -e "\033[1;32m|=== INSTALLING THE RUST TOOLCHAIN ===|\033[0m"
rm rust.sh
curl -sSf https://sh.rustup.rs >> rust.sh 
chmod +x rust.sh
./rust.sh -y
source "$HOME/.cargo/env"
source ~/.bashrc
echo ""

# Installing cargo binstall
echo -e "\033[1;32m|=== INSTALLING CARGO BINSTALL ==="
cargo install cargo-binstall
echo ""

