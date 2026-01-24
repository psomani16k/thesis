#!/bin/bash

# Install alacritty 
echo -e "\033[1;32m|=== INSTALLING AND SETTING UP ALACRITTY ===|\033[0m"
sudo dnf install -y alacritty
echo ""

# Setting up CaskaydiaCove fonts
mkdir ~/.fonts
pwd
cp ./alacritty/CascadiaCode/* ~/.fonts
sudo fc-cache -fv
