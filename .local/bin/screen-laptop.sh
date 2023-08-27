#!/bin/sh
xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off --output DisplayPort-4 --off
xset s 360 360 +dpms
notify-send -t 3000 "Screensaver Enabled!"
