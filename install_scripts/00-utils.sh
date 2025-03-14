#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
ACTION="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

function install_package {
	if pacman -Q $1 &> /dev/null; then
		echo "${OK} $1 is already installed." | tee -a "$LOG"
	else
		echo "${NOTE} Install $1.........." | tee -a "$LOG"

		if sudo pacman -S --noconfirm $1; then
			echo "👌 ${OK} $1 has been installed successfully." | tee -a "$LOG"
		else
			echo "${ERROR} $1 not found nor cannot be installed." | tee -a "$LOG"
			echo "${ACTION} Please install $1 manually before running this script... Exiting" | tee -a "$LOG"
			exit 1
		fi
	fi
}

function install_package_paru {
	if paru -Q $1 &> /dev/null; then
		echo "${OK} $1 is already installed." | tee -a "$LOG"
	else
		echo "${NOTE} Install (AUR) $1.........." | tee -a "$LOG"

		if sudo paru -S --noconfirm $1; then
			echo "👌 ${OK} $1 has been installed successfully." | tee -a "$LOG"
		else
			echo "${ERROR} $1 not found nor cannot be installed." | tee -a "$LOG"
			echo "${ACTION} Please install $1 manually before running this script... Exiting" | tee -a "$LOG"
			exit 1
		fi
	fi
}

function check_conflict_package {
	if pacman -Q $1 &> /dev/null; then
		echo "${ERROR} $1 package conflict with new config." | tee -a "$LOG"
		echo "${ACTION} Please uninstall $1 manually before running this script... Exiting" | tee -a "$LOG"
		exit 1
	fi
}
