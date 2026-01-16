#!/bin/sh

actual="Discharging"

while true; do
	status="$(acpi -b | awk '{print substr($3, 1, length($3)-1)}')"
	
	if [ "$status" != "$actual" ]; then
		actual="$status"
		notify-send "$status"
	fi

	sleep 1s
done
