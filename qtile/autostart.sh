#!/bin/sh
wlr-randr --output eDP-1 --mode 1920x1080@60.000999Hz &
xwayland-satellite & 
libinput-gestures-setup start &
hypridle &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dunst &
