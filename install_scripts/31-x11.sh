#!/bin/bash

echo -e "\n${INFO} Running 04-x11" | tee -a "$LOG"

# X11 support
install_package xorg-server   
install_package xorg-xrandr
install_package xclip
install_package xsecurelock

install_package picom
install_package arandr
install_package autorandr

# Update X11 keymap
sudo localectl set-x11-keymap fr
echo "${OK} X11 keymap update to: fr"

# Add X11 touchpad config
sudo sh -c 'echo -e "Section \"InputClass\"" > /etc/X11/xorg.conf.d/30-touchpad.conf'
sudo sh -c 'echo -e "\tIdentifier \"devname\"\n\tDriver \"libinput\"\n\tMatchIsTouchpad \"on\"\n" >> /etc/X11/xorg.conf.d/30-touchpad.conf'
sudo sh -c 'echo -e "\tOption \"Tapping\" \"on\"\n\tOption \"ClickMethod\" \"clickfinger\"\n\tOption \"NaturalScrolling\" \"true\"\nEndSection\n" >> /etc/X11/xorg.conf.d/30-touchpad.conf'
echo "${OK} X11 touchpad setting write to /etc/X11/xorg.conf.d/30-touchpad.conf"

echo -e "\n${OK} X11 Installation and services setup complete!" 2>&1 | tee -a "$LOG"
