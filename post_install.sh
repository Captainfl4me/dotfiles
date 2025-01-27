#!/bin/bash

## TODO
# Remove iwd if nm is working
# add audio
# add samsung galaxy custom driver
# check if i3 shortcut are all installed

echo "== POST INSTALL SCRIPT =="

# Save dotfile script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
echo "running from : ${SCRIPT_DIR}"

# Start with pacman upgrade
sudo pacman -Syu --noconfirm

# Check if PARU (AUR helper exist, if not install)
if ! command -v paru 2>&1 > /dev/null
then
	if ! command -v rustup 2>&1 > /dev/null
	then
		sudo pacman -S --noconfirm rustup
		rustup default stable
	fi
	echo "Paru not found, installing..."
	mkdir -p ~/aur
	sudo pacman -S --needed --noconfirm base-devel git
	cd ~/aur
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	cd ${SCRIPT_DIR}
fi

# Install and exec stow
sudo pacman -S --needed --noconfirm stow
stow .

# Install all Pacman package needed
sudo pacman -S --needed --noconfirm xorg-server xorg-xrandr xclip picom feh cronie i3-wm polybar lightdm lightdm-slick-greeter light-locker accountsservice rofi alacritty flameshot noto-fonts-emoji numlockx curl wget zsh zsh-completions openssh dnsmasq

# Install all Paru package needed
paru -S --needed --noconfirm ttf-twemoji-color ttf-mononoki-nerd lux wired oh-my-zsh-git
sudo lux # Need to be run once as root

# Install apps
sudo pacman -S --needed --noconfirm rclone discord firefox wireshark-qt docker docker-compose nodejs npm python fastfetch python-pynvim ripgrep luarocks lazygit
paru -S --needed --noconfirm 1password
sudo npm install -g tree-sitter-cli neovim

# Configure NetworkManager
sudo sh -c 'echo "[main]" > /etc/NetworkManager/conf.d/dns.conf'
sudo sh -c 'echo "dns=dnsmasq" >> /etc/NetworkManager/conf.d/dns.conf'

# Install dynamic-wallpaper
if ! command -v dwall 2>&1 > /dev/null
then
	echo "Dynamic-wallpaper not found, installing..."
	mkdir -p ~/aur
	cd ~/aur
	git clone https://github.com/adi1090x/dynamic-wallpaper.git
	cd dynamic-wallpaper
	chmod +x install.sh
	./install.sh
	cd ${SCRIPT_DIR}
fi

# Install Samsung custom drivers

# Numlock default on
touch ~/.xinitrc
NUMLOCK_CMD="numlockx &"
if grep -q "${NUMLOCK_CMD}" ~/.xinitrc; then
	echo "Numlock already activated"
else
	if [ -s ~/.xinitrc ]; then
		echo "Inserting Numlock in ~/.xinitrc"
		sed -i "1i${NUMLOCK_CMD}" ~/.xinitrc
	else
		echo "Copying Numlock in ~/.xinitrc"
		echo ${NUMLOCK_CMD} > ~/.xinitrc
	fi
fi

# Change lightDM greeter
SEAT_LINE=$(cat /etc/lightdm/lightdm.conf | grep -i -n "^\[Seat:\*\]" | grep -o "[0-9]*")
GREETER_LINE_RELATIVE=$(tail --lines="+${SEAT_LINE}" /etc/lightdm/lightdm.conf | grep -i -n "greeter-session=" | grep -o "[0-9]*")
GREETER_LINE_ABS=$((10#${SEAT_LINE} + 10#${GREETER_LINE_RELATIVE} - 10#1))
echo "Updating /etc/lightdm/lightdm.conf: line ${GREETER_LINE_ABS}"
if [ ! -z ${GREETER_LINE_ABS} ]; then
	sudo sed -i "${GREETER_LINE_ABS}s/.*/greeter-session=lightdm-slick-greeter/" /etc/lightdm/lightdm.conf
else
	echo "WARNING: GREETER_LINE_ABS empty!"
fi
# Numlock for lightDM
GREETER_SCRIPT_LINE_RELATIVE=$(tail --lines="+${SEAT_LINE}" /etc/lightdm/lightdm.conf | grep -i -n "greeter-setup-script=" | grep -o "[0-9]*")
GREETER_SCRIPT_LINE_ABS=$((10#${SEAT_LINE} + 10#${GREETER_SCRIPT_LINE_RELATIVE} - 10#1))
echo "Updating /etc/lightdm/lightdm.conf: line ${GREETER_SCRIPT_LINE_ABS}"
if [ ! -z ${GREETER_SCRIPT_LINE_ABS} ]; then
	sudo sed -i "${GREETER_SCRIPT_LINE_ABS}s/.*/greeter-setup-script=\/usr\/bin\/numlockx on/" /etc/lightdm/lightdm.conf
else
	echo "WARNING: GREETER_SCRIPT_LINE_ABS empty!"
fi

# Add X11 touchpad config
sudo sh -c 'echo -e "Section \"InputClass\"" > /etc/X11/xorg.conf.d/30-touchpad.conf'
sudo sh -c 'echo -e "\tIdentifier \"devname\"\n\tDriver \"libinput\"\n\tMatchIsTouchpad \"on\"\n" >> /etc/X11/xorg.conf.d/30-touchpad.conf'
sudo sh -c 'echo -e "\tOption \"Tapping\" \"on\"\n\tOption \"ClickMethod\" \"clickfinger\"\n\tOption \"NaturalScrolling\" \"true\"\nEndSection\n" >> /etc/X11/xorg.conf.d/30-touchpad.conf'

# Update X11 keymap
echo "Update X11 keymap"
sudo localectl set-x11-keymap fr

# Groups management
echo "Groups management"
sudo usermod -aG wireshark $USER
sudo usermod -aG docker $USER

# Setup subuid and subgid
echo "Setup subuid and subgid"
sudo sh -c 'echo "nicoth:100000:65536" > /etc/subuid'
sudo sh -c 'echo "nicoth:100000:65536" > /etc/subgid'

# Enable jobs
echo "Enable jobs"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now cronie
sudo systemctl enable --now docker.socket

# Make sure lightdm is enable and running
sudo systemctl enable --now lightdm
