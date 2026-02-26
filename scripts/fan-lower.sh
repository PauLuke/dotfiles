#!/usr/bin/env bash

# Percent to change
STEP=1

# Get the current fan speed
# 'grep "Target Fan Speed"' keep only the desired lines (Target Fan Speed : 20.00).
# 'head -n 1' ensures we only take the first fan speed in case there are multiple fans.
# 'awk {print $NF}' split fields and prints the last one (20.00).
# 'cut -d. -f1' use '.' as delimiter and takes the first field (20).
RAW_STATUS=$(nbfc status | grep "Target Fan Speed" | head -n 1 | awk '{print $NF}')
CURRENT_SPEED=$(echo "$RAW_STATUS" | cut -d. -f1)

# Fallback: If nbfc status fails, default to 50
if [ -z "$CURRENT_SPEED" ]; then
    CURRENT_SPEED=50
fi

# Calculate New Speed
NEW_SPEED=$(( CURRENT_SPEED - STEP ))

# Keep values between 0 and 100)
if [ "$NEW_SPEED" -gt 100 ]; then
    NEW_SPEED=100
elif [ "$NEW_SPEED" -lt 0 ]; then
    NEW_SPEED=0
fi

# Apply the new speed
nbfc set -s "$NEW_SPEED"
