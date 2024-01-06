#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="/opt/dotdot/polybar/.config/polybar/blocks"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
# polybar -q main -c "$DIR"/config.ini &


echo $DIR/config.ini
for m in $(polybar --list-monitors | cut -d":" -f1); do
    if hostname | grep pop-os 
    then
        HEIGHT=33 INTERFACE=wlp0s20f3 MONITOR=$m polybar -q main -c "$DIR/config.ini" &	
    else
        HEIGHT=33 INTERFACE=wlan0 MONITOR=$m polybar -q main -c "$DIR/config.ini" &	
    fi
done
    # polybar -q main -c "$DIR/config.ini" &

