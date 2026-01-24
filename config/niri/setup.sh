#!/bin/bash

# Installing niri
# echo -e "\033[1;32m|=== INSTALLING AND SETTING UP NIRI FROM LATEST GIT ===|\033[0m"

# Installing from package manager
echo -e "\033[1;32m|=== INSTALLING AND SETTING UP NIRI FROM PACKAGE ===|\033[0m"
sudo dnf copr enable yalter/niri-git -y
echo "priority=1" | sudo tee -a /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo
sudo dnf install niri -y
systemctl --user add-wants niri.service dms
echo ""
