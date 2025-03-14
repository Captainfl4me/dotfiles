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

if [[ ! -d ~/aur/samsung-galaxybook-extras ]]
then
	echo "${NOTE} Install Samsung driver.........." | tee -a "$LOG"
	cd ~/aur
	git clone https://github.com/joshuagrisham/samsung-galaxybook-extras.git || { printf "%s - Failed to clone ${YELLOW}samsung-galaxybook-extras${RESET}\n" "${ERROR}"; exit 1; }
	sudo dkms add ~/aur/samsung-galaxybook-extras
	cd ${SCRIPT_DIR}
else
	echo "${NOTE} Update Samsung driver.........." | tee -a "$LOG"
	cd ~/aur/samsung-galaxybook-extras
	git pull
	cd ${SCRIPT_DIR}
fi
sudo dkms build samsung-galaxybook/extras
sudo dkms install samsung-galaxybook/extras
sudo mkinitcpio -P

echo -e "${NOTE} Writing ${YELLOW}necessary-verbs${RESET} crontab..."
echo -e "0 * * * * env PATH=$PATH DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS /usr/bin/zsh /home/nicoth/aur/galaxy-book2-pro-linux/sound/necessary-verbs.sh" | sudo crontab -

echo -e "\n${OK} Specific Installation and services setup complete!" 2>&1 | tee -a "$LOG"
