#!/bin/bash

echo -e "\n${INFO} Running 32-i3wm" | tee -a "$LOG"

# Bluetooth support
install_package i3-wm
install_package polybar
install_package feh
install_package rofi
install_package flameshot
install_package xsecurelock
install_package mplayer
install_package xss-lock

install_package dolphin
install_package network-manager-applet 

install_package_paru wired


# Install dynamic-wallpaper
if command -v dwall 2>&1 > /dev/null; then
	echo "${OK} dwall is already installed." | tee -a "$LOG"
else
	echo "${NOTE} Install (MANUAL) dwall.........." | tee -a "$LOG"

	mkdir -p ~/aur
	cd ~/aur
	git clone https://github.com/adi1090x/dynamic-wallpaper.git || { printf "${ERROR} Failed to clone ${YELLOW}dynamic-wallpaper${RESET}\n"; exit 1; }
	cd dynamic-wallpaper
	chmod +x install.sh
	./install.sh || { printf "${ERROR} Failed to install ${YELLOW}dynamic-wallpaper${RESET}\n"; exit 1; }

	echo "👌 ${OK} dwall has been installed successfully." | tee -a "$LOG"
	cd ${SCRIPT_DIR}
fi

echo "${NOTE} Update Symlink for ROFI config"
ln -sf rofi-i3 .config/rofi

echo -e "${NOTE} Writing ${YELLOW}dwall${RESET} crontab..."
echo -e "0 * * * * env PATH=$PATH DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS /usr/bin/dwall -s lakeside" | crontab -

echo -e "\n${OK} i3-wm Installation and services setup complete!" 2>&1 | tee -a "$LOG"
