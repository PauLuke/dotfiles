#!/usr/bin/env bash

# if grep owner_pid /proc/asound/card*/pcm*c/sub*/status > /dev/null 2>&1; then
if pactl list sources | grep -A 50 "State: RUNNING" | grep -q "media.class = \"Audio/Source\""; then
  exit 0
else
  exit 1
fi
