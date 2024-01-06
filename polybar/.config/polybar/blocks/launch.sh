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
        HEIGHT=33 FONT0=11 FONT0=22 MONITOR=$m polybar -q main -c "$DIR/config.ini" &	
done
# polybar -q main -c "$DIR/config.ini" &

