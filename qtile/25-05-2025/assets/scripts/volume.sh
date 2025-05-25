#!/bin/bash

# Function to get volume and mute status
get_volume_info() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep 'Volume:' | awk '{print $5}' | sed 's/%//'
}

get_mute_status() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep 'Mute:' | awk '{print $2}'
}

# Send notification
send_notification() {
    VOLUME=$(get_volume_info)
    MUTE=$(get_mute_status)

    if [ "$MUTE" == "yes" ]; then
        ICON="audio-volume-muted" # Or any other appropriate muted icon
        dunstify -a "volume" -u low -i $ICON "Volume Muted" -h string:x-dunst-stack-tag:volume_notification
    else
        # Choose an icon based on volume level
        if (( VOLUME == 0 )); then
            ICON="audio-volume-off"
        elif (( VOLUME < 33 )); then
            ICON="audio-volume-low"
        elif (( VOLUME < 66 )); then
            ICON="audio-volume-medium"
        else
            ICON="audio-volume-high"
        fi
        dunstify -a "volume" -u low -i $ICON "Volume: ${VOLUME}%" -h int:value:"$VOLUME" -h string:x-dunst-stack-tag:volume_notification
    fi
}

# Handle volume actions
case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        send_notification
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        send_notification
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac
