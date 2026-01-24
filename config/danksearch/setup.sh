#!/bin/bash

# Installing dsearch
echo -e "\033[1;32m|=== INSTALLING AND SETTINGUP DSEARCH ===|\033[0m"
sudo dnf copr enable avengemedia/danklinux -y
sudo dnf install dsearch -y
dsearch index generate
echo ""
