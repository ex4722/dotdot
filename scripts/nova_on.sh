#!/bin/sh
if hostname | grep "nova"
then
    xrandr --output eDP1 --mode 1920x1080 --pos 2560x360 --rotate normal --output DP1 --off --output DP2 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off --output VIRTUAL2 --off
else
    xrandr --output eDP-1 --primary --mode 1920x1200 --pos 2560x240 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --mode 2560x1440 --pos 0x0 --rotate normal
fi

i3-msg reload
i3-msg restart

nitrogen --restore

