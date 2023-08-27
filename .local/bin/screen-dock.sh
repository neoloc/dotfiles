#!/bin/sh
xrandr --output eDP --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --mode 2560x1440 --pos 0x615 --rotate normal --output DisplayPort-3 --mode 2560x1440 --pos 2560x0 --rotate left --output DisplayPort-4 --off
xset s 0 0 -dpms
notify-send -t 3000 "Screensaver Disabled!"
