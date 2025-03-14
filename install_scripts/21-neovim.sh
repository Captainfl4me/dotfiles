#!/bin/bash

echo -e "\n${INFO} Running 21-neovim script" | tee -a "$LOG"

install_package neovim
install_package ripgrep
install_package luarocks
install_package lazygit
install_package nodejs
install_package npm 
install_package python 
install_package python-pynvim
install_package cmake
install_package clang

echo -e "\n${OK} Neovim Installation setup complete!" 2>&1 | tee -a "$LOG"
