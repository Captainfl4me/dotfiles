#!/bin/bash

XRANDR_MONITOR=$(xrandr --query |awk '/\<connected\>/{print $4}')
MONITOR_WIDTH=$(echo $XRANDR_MONITOR | awk -F  'x' '{print $1}')
MONITOR_HEIGHT=$(echo $XRANDR_MONITOR | awk -F  'x' '{print $2}' | awk -F  '+' '{print $1}')

mplayer -noconsolecontrols \
  -really-quiet \
  -nostop-xscreensaver \
  -fs \
  -heartbeat-cmd "" \
  -wid "${XSCREENSAVER_WINDOW}" \
  -fixed-vo \
  -nosound \
  -vf crop=$MONITOR_WIDTH:$MONITOR_HEIGHT:0:0 \
  /home/nicoth/dotfiles/sddm_theme/pixel_sakura.gif
