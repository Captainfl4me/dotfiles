#!/bin/bash

echo -e "\n${INFO} Running 04-network script" | tee -a "$LOG"

install_package networkmanager
install_package dnsmasq

printf "${NOTE} Writing ${YELLOW}NetworkManager${RESET} config...\n"
sudo sh -c 'echo "[main]" > /etc/NetworkManager/conf.d/dns.conf'
sudo sh -c 'echo "dns=dnsmasq" >> /etc/NetworkManager/conf.d/dns.conf'

printf "${NOTE} Activating ${YELLOW}NetworkManager${RESET} Services...\n"
sudo systemctl enable --now NetworkManager 2>&1 | tee -a "$LOG"

echo -e "\n${OK} Networking Installation and services setup complete!" 2>&1 | tee -a "$LOG"
