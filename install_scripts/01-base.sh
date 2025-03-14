#!/bin/bash

echo -e "\n${INFO} Running 01-base script" | tee -a "$LOG"

# Check if base packages are installed
install_package base-devel
install_package git
install_package rustup
install_package stow
install_package cronie
install_package ufw
install_package dkms
install_package linux-headers
install_package curl
install_package wget
install_package openssh
rustup default stable

# Check if PARU (AUR helper exist, if not install)
if pacman -Q paru &> /dev/null; then
	echo "${OK} Paru is already installed." | tee -a "$LOG"
else
	echo "${NOTE} Install Paru.........." | tee -a "$LOG"
	mkdir -p ~/aur
	cd ~/aur
	git clone https://aur.archlinux.org/paru.git || { printf "%s - Failed to clone ${YELLOW}Paru${RESET} from AUR\n" "${ERROR}"; exit 1; }
	cd paru
	makepkg -si --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to install ${YELLOW}$pkg${RESET} from AUR\n" "${ERROR}"; exit 1; }

	echo "${OK} Paru install successfully!!" | tee -a "$LOG"
	cd ${SCRIPT_DIR}
fi


printf "${NOTE} Writing ${YELLOW}subuid${RESET} and ${YELLOW}subgid${RESET}...\n"
sudo sh -c "echo '${USER}:100000:65536' > /etc/subuid"
sudo sh -c "echo '${USER}:100000:65536' > /etc/subgid"

printf "${NOTE} Activating ${YELLOW}Cronie${RESET} Services...\n"
sudo systemctl enable --now cronie.service
printf "${NOTE} Activating ${YELLOW}UFW${RESET} Services...\n"
sudo systemctl enable --now ufw.service
printf "${NOTE} Activating ${YELLOW}power-profiles-daemon${RESET} Services...\n"
sudo systemctl enable --now power-profiles-daemon.service

echo -e "\n${OK} Base Installation and services setup complete!" 2>&1 | tee -a "$LOG"
