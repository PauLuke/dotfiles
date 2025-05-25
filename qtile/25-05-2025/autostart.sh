#!/bin/sh
libinput-gestures-setup start &
hypridle &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
wlsunset -S 7:00 -s 17:00 -t 3500 -T 6000 &
dunst &
