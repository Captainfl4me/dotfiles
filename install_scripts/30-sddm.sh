#!/bin/bash

echo -e "\n${INFO} Running 30-sddm script" | tee -a "$LOG"

check_conflict_package lightdm

install_package qt6-5compat 
install_package qt6-declarative 
install_package qt6-svg
install_package qt6-virtualkeyboard
install_package qt6-multimedia-ffmpeg
install_package sddm

printf "${NOTE} Writing ${YELLOW}numlock${RESET} config...\n"
sudo sh -c 'echo "[General]" > /etc/sddm.conf.d/numlock.conf'
sudo sh -c 'echo "Numlock=on" >> /etc/sddm.conf.d/numlock.conf'

printf "${NOTE} Writing ${YELLOW}theme${RESET} config...\n"
sudo mkdir -p /etc/sddm.conf.d/
echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
echo -e "[General]\nInputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
sudo mkdir -p /usr/share/sddm/themes/sddm-astronaut-theme/
sudo cp -r ./sddm_theme/* /usr/share/sddm/themes/sddm-astronaut-theme/

printf "${NOTE} Activating ${YELLOW}SDDM${RESET} Services...\n"
sudo systemctl enable sddm

echo -e "\n${OK} SDDM Installation and services setup complete!" 2>&1 | tee -a "$LOG"
