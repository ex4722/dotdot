#! /bin/bash 
nitrogen --restore & 
xmodmap /home/ex/.Xmodmap &
picom &
xss-lock -- i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts &
emacs --daemon &
# $HOME/.config/polybar/polybar.sh
# picom -CG --no-fading-openclose --no-fading-openclose --fade-in-step=1 --fade-out-step=1 --fade-delta=0
