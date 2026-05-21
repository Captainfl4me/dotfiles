#!/bin/bash

echo -e "\n${INFO} Running specific SAMSUNG-Arch-Nico script" | tee -a "$LOG"

if [[ ! -d ~/aur/galaxy-book2-pro-linux ]]
then
	echo "${NOTE} Install Samsung utils.........." | tee -a "$LOG"
	cd ~/aur
	git clone https://github.com/joshuagrisham/galaxy-book2-pro-linux.git || { printf "%s - Failed to clone ${YELLOW}galaxy-book2-pro-linux${RESET}\n" "${ERROR}"; exit 1; }
	cd ${SCRIPT_DIR}
else
	echo "${NOTE} Update Samsung utils.........." | tee -a "$LOG"
	cd ~/aur/galaxy-book2-pro-linux
	git pull
	cd ${SCRIPT_DIR}
fi

echo -e "\n${OK} Specific Installation and services setup complete!" 2>&1 | tee -a "$LOG"
