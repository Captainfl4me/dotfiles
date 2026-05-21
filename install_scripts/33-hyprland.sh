#!/bin/bash

echo -e "\n${INFO} Running 33-hyprland script" | tee -a "$LOG"

# ALSA extended support
install_package hyprland
install_package hypridle
install_package hyprlock
install_package hyprcursor
install_package hyprpolkitagent

install_package waybar
install_package rofi-wayland
install_package wl-clipboard
install_package swaync

install_package_paru wlogout

echo "${NOTE} Update Symlink for ROFI config"
ln -sf rofi-wayland .config/rofi

echo -e "\n${OK} Hyprland Installation and services setup complete!" 2>&1 | tee -a "$LOG"
