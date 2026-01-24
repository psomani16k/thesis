#!/bin/bash

# Setup fish
source ~/.config/fish/setup.sh

# Any script that acts as a init script
# that other scripts depend on comes here 
source ~/.config/setup_misc/setup.sh

# Setup alacritty
source ~/.config/alacritty/setup.sh

# Setup zellij
source ~/.config/zellij/setup.sh

# Setup neovim
source ~/.config/nvim/setup.sh

# Setup starship - put this here as no dedicated starship folder
echo -e "\033[1;32m|=== INSTALLING STARSHIP ===|\033[0m"
cargo binstall starship -y
echo ""

# Setup dms
source ~/.config/DankMaterialShell/setup.sh

# Setup danksearch
source ~/.config/danksearch/setup.sh

# Setup niri
source ~/.config/niri/setup.sh

