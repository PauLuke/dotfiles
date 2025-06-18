#!/bin/bash

# Define the display device. You might need to adjust this.
# You can find your device name by running 'brightnessctl info'.
# Common device names are 'intel_backlight', 'amdgpu_bl0', or similar.
DEVICE="intel_backlight" # <--- IMPORTANT: Adjust this to your actual backlight device!

# Check if the device exists, if not, try to find a default
if ! brightnessctl -d "$DEVICE" info &>/dev/null; then
    DEVICE=$(brightnessctl info | grep -oP 'Device: \K[^ ]+')
    if [ -z "$DEVICE" ]; then
        # Fallback if no device is found
        dunstify -a "brightness" -u critical "Brightness Error" "No backlight device found. Please check 'brightnessctl info'."
        exit 1
    fi
fi


# Function to get current brightness percentage
get_brightness_percentage() {
    brightnessctl -d "$DEVICE" g | xargs -I{} echo "scale=0; {} * 100 / $(brightnessctl -d "$DEVICE" m)" | bc
}

# Send notification
send_notification() {
    BRIGHTNESS=$(get_brightness_percentage)

    # Choose an icon based on brightness level (you might need to install icon themes)
    if (( BRIGHTNESS == 0 )); then
        ICON="display-brightness-off" # Or a suitable icon
    elif (( BRIGHTNESS < 33 )); then
        ICON="display-brightness-low"
    elif (( BRIGHTNESS < 66 )); then
        ICON="display-brightness-medium"
    else
        ICON="display-brightness-high"
    fi

    # Send a dunst notification
    dunstify -a "brightness" -u low -i $ICON "Brightness: ${BRIGHTNESS}%" -h int:value:"$BRIGHTNESS" -h string:x-dunst-stack-tag:brightness_notification
}

# Handle brightness actions
case "$1" in
    up)
        # Increase brightness by 1% of max
        brightnessctl -d "$DEVICE" set +1%
        send_notification
        ;;
    down)
        # Decrease brightness by 1% of max
        brightnessctl -d "$DEVICE" set 1%-
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac
