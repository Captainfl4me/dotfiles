#!/bin/bash

## TODO
# add grub setup
# add lightdm greeter config (wallpaper)
# add multilib
# check if i3 shortcut are all installed

source ./install_scripts/00-utils.sh

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi
LOG="Install-Logs/Install-Scripts-$(date +%d-%H%M%S).log"

clear

echo "${GREEN}2025 Archlinux${RESET}" | tee -a "$LOG"
printf "\n%.0s" {1..1}
echo -e "\e[35m
   ______            __        _          ________              
  / ____/___  ____  / / ____  (_)___     / ____/ /___  ____ ___ 
 / /   / __ \\/ __ \\/ __/ __ \\/ / __ \\   / /_  / / __ \/ __ \__ \\
/ /___/ /_/ / /_/ / /_/ /_/ / / / / /  / __/ / / /_/ / / / / / /
\\____/\\__,_/ .___/\\__/\\__,_/_/_/ /_/  /_/   /_/\\__,_/_/ /_/ /_/
          /_/
\e[0m"
printf "\n%.0s" {1..1}

echo "${GREEN}== INSTALL SCRIPT ==${RESET}" | tee -a "$LOG"

# Save dotfile script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
echo "${INFO} running from ${SCRIPT_DIR}" | tee -a "$LOG"

if [[ $EUID -eq 0 ]]; then
    echo "${ERROR}  This script should ${WARNING}NOT${RESET} be executed as root!! Exiting......." | tee -a "$LOG"
    printf "\n%.0s" {1..2} 
    exit 1
fi

# Do Pacman full upgrade
echo "${NOTE} pacman upgrading..." | tee -a "$LOG"
sudo pacman -Syu --noconfirm
echo "	${OK} pacman upgrade successful" | tee -a "$LOG"

source ./install_scripts/01-base.sh

stow .

source ./install_scripts/02-audio.sh

echo "Run bluetooth support script ? [Y/n]"
read answer

if [ "$answer" != "${answer#[Yy]}" ] || [ "$answer" = "" ]; then
	source ./install_scripts/03-bluetooth.sh
fi

source ./install_scripts/10-fonts.sh
source ./install_scripts/20-terminal.sh
source ./install_scripts/21-neovim.sh

source ./install_scripts/30-sddm.sh
echo -e "Choose Window System: \n\t1)X11 / i3 (default)\n\t2)Wayland / Hyprland"
read answer
if [ "$answer" != "${answer#[1]}" ] || [ "$answer" = "" ]; then
	source ./install_scripts/31-x11.sh
	source ./install_scripts/32-i3.sh
# elif if [ "$answer" != "${answer#[2]}" ]; then
fi

SPECIFIC_SCRIPT_PATH="./install_scripts/$(</etc/hostname).sh"
if [ -f $SPECIFIC_SCRIPT_PATH ]; then
	source $SPECIFIC_SCRIPT_PATH
fi

echo -e "\n${OK} POST Installation and services setup complete!" 2>&1 | tee -a "$LOG"

exit 0









# Install all Pacman package needed
# lightdm: lightdm lightdm-slick-greeter light-locker accountsservice || lightdm-settings
sudo pacman -S --needed --noconfirm numlockx   power-profiles-daemon libsecret gnome-keyring python-setuptools fuse3 gnome-backgrounds

# Install all Paru package needed
paru -S --needed --noconfirm lux mkinitcpio-numlock hyperfluent-grub-theme-arch
sudo lux # Need to be run once as root

# Install apps
sudo pacman -S --needed --noconfirm rclone discord firefox wireshark-qt docker docker-compose docker-buildx github-cli htop putty thunderbird  gdb 
paru -S --needed --noconfirm 1password gf2-git 
sudo npm install -g tree-sitter-cli neovim '@hyperupcall/autoenv'

# Configure NetworkManager

# Conf initramfs
RAMFS_HOOKS_LINE=$(cat /etc/mkinitcpio.conf | grep -i -n '^HOOKS=' | grep -oP '\K[0-9]*(?=:)')
echo "Updating /etc/mkinitcpio.conf: line ${RAMFS_HOOKS_LINE}"
sudo sed -i "${RAMFS_HOOKS_LINE}s/.*/HOOKS=\(base udev autodetect microcode modconf kms keyboard keymap consolefont numlock block filesystems resume fsck\)/" /etc/mkinitcpio.conf

# Change lightDM greeter
SEAT_LINE=$(cat /etc/lightdm/lightdm.conf | grep -i -n "^\[Seat:\*\]" | grep -oP '\K[0-9]*(?=:)')
GREETER_LINE_RELATIVE=$(tail --lines="+${SEAT_LINE}" /etc/lightdm/lightdm.conf | grep -i -n "greeter-session=" | grep -oP '\K[0-9]*(?=:)')
GREETER_LINE_ABS=$((10#${SEAT_LINE} + 10#${GREETER_LINE_RELATIVE} - 10#1))
echo "Updating /etc/lightdm/lightdm.conf: line ${GREETER_LINE_ABS}"
if [ ! -z ${GREETER_LINE_ABS} ]; then
	sudo sed -i "${GREETER_LINE_ABS}s/.*/greeter-session=lightdm-slick-greeter/" /etc/lightdm/lightdm.conf
else
	echo "WARNING: GREETER_LINE_ABS empty!"
fi
# Numlock for lightDM
GREETER_SCRIPT_LINE_RELATIVE=$(tail --lines="+${SEAT_LINE}" /etc/lightdm/lightdm.conf | grep -i -n "greeter-setup-script=" | grep -oP '\K[0-9]*(?=:)')
GREETER_SCRIPT_LINE_ABS=$((10#${SEAT_LINE} + 10#${GREETER_SCRIPT_LINE_RELATIVE} - 10#1))
echo "Updating /etc/lightdm/lightdm.conf: line ${GREETER_SCRIPT_LINE_ABS}"
if [ ! -z ${GREETER_SCRIPT_LINE_ABS} ]; then
	sudo sed -i "${GREETER_SCRIPT_LINE_ABS}s/.*/greeter-setup-script=\/usr\/bin\/numlockx on/" /etc/lightdm/lightdm.conf
else
	echo "WARNING: GREETER_SCRIPT_LINE_ABS empty!"
fi

# GRUB Setup
sudo mkdir -p /boot/grub/themes/
sudo cp -r /usr/share/grub/themes/hyperfluent-grub-theme-arch/ /boot/grub/themes/
echo "Writing GRUB config"
GRUB_DEFAULT_LINE=$(cat /etc/default/grub | grep -i -n "^GRUB_DEFAULT=" | grep -oP '\K[0-9]*(?=:)')
echo "GRUB_DEFAULT at ${GRUB_DEFAULT_LINE}"
if [ ! -z ${GRUB_DEFAULT_LINE} ]; then
	sudo sed -i "${GRUB_DEFAULT_LINE}s/.*/GRUB_DEFAULT=saved/" /etc/default/grub
fi

GRUB_SAVEDEFAULT_LINE=$(cat /etc/default/grub | grep -i -n "GRUB_SAVEDEFAULT=" | grep -oP '\K[0-9]*(?=:)')
echo "GRUB_SAVEDEFAULT at ${GRUB_SAVEDEFAULT_LINE}"
if [ ! -z ${GRUB_SAVEDEFAULT_LINE} ]; then
	sudo sed -i "${GRUB_SAVEDEFAULT_LINE}s/.*/GRUB_SAVEDEFAULT=true/" /etc/default/grub
fi

GRUB_THEME_LINE=$(cat /etc/default/grub | grep -i -n "GRUB_THEME=" | grep -oP '\K[0-9]*(?=:)')
echo "GRUB_THEME at ${GRUB_THEME_LINE}"
if [ ! -z ${GRUB_THEME_LINE} ]; then
	sudo sed -i "${GRUB_THEME_LINE}s/.*/GRUB_THEME=\/boot\/grub\/themes\/hyperfluent-grub-theme-arch\/theme\.txt/" /etc/default/grub
fi
# sudo grub-mkconfig -o /boot/grub/grub.cfg

# Groups management
echo "Groups management"
sudo usermod -aG wireshark $USER
sudo usermod -aG docker $USER
sudo usermod -aG uucp $USER 

sudo systemctl enable --now docker.socket

# Make sure lightdm is enable and running
sudo systemctl enable --now lightdm
