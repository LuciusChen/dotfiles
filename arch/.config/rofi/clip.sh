#!/bin/bash

# Check if Rofi is running with the specific cliphist command
if pgrep -f "rofi -dmenu" > /dev/null; then
    # If Rofi is running, kill it
    pkill -f "rofi -dmenu"
else
    # If Rofi is not running, start cliphist with rofi
    cliphist list | rofi -dmenu | cliphist decode | wl-copy
fi
