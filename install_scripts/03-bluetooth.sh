#!/bin/bash

echo -e "\n${INFO} Running 03-bluetooth script" | tee -a "$LOG"

# Bluetooth support
install_package bluez
install_package bluez-utils
install_package blueman


printf "${NOTE} Activating ${YELLOW}Bluetooth${RESET} Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Bluetooth Installation and services setup complete!" 2>&1 | tee -a "$LOG"
