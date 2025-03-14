#!/bin/bash

echo -e "\n${INFO} Running 10-fonts script" | tee -a "$LOG"

install_package noto-fonts-emoji

install_package_paru ttf-twemoji-color 
install_package_paru ttf-mononoki-nerd

sudo cp -r ./fonts/* /usr/share/fonts/

echo -e "\n${OK} Fonts Installation setup complete!" 2>&1 | tee -a "$LOG"
