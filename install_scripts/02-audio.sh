#!/bin/bash

echo -e "\n${INFO} Running 02-audio script" | tee -a "$LOG"

# ALSA extended support
install_package sof-firmware
install_package alsa-firmware
install_package alsa-utils

check_conflict_package pulseaudio

# Pipewire
install_package pipewire
install_package wireplumber
install_package pipewire-audio
install_package pipewire-alsa
install_package pipewire-pulse

echo -e "${NOTE} Activating ${YELLOW}Pipewire${RESET} Services..."
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>&1 | tee -a "$LOG"
systemctl --user enable --now pipewire.service 2>&1 | tee -a "$LOG"

install_package pavucontrol

echo -e "\n${OK} Pipewire Installation and services setup complete!" 2>&1 | tee -a "$LOG"
