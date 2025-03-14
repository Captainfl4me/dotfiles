#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu

# Current Theme
dir="$HOME/.config/rofi/powermenu"

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'
yes=' '
no='󰜺 '

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye ${USER}" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/powermenu.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Are you Sure?' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			systemctl hibernate
		elif [[ $1 == '--logout' ]]; then
			i3-msg exit
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		env XSECURELOCK_SAVER=saver_xscreensaver xsecurelock
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
