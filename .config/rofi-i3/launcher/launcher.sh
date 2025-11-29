#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)

dir="$HOME/.config/rofi/launcher"
theme='style-10'

## Run
rofi \
    -show drun \
    -theme ${dir}/launcher.rasi
