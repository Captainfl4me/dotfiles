#!/bin/bash

echo -e "\n${INFO} Running 20-terminal script" | tee -a "$LOG"

install_package zsh 
install_package zsh-completions 
install_package alacritty
install_package fastfetch

install_package_paru oh-my-zsh-git

echo -e "\n${OK} Terminal Installation and services setup complete!" 2>&1 | tee -a "$LOG"
