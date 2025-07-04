#!/bin/bash

# Check if Rofi is running in drun mode
if pgrep -f "rofi -show drun" > /dev/null; then
    # If Rofi is running in drun mode, kill it
    pkill -f "rofi -show drun"
    cliphist list | rofi -dmenu | cliphist decode | wl-copy
elif pgrep -f "rofi -dmenu" > /dev/null; then
    # If Rofi is running in dmenu mode, kill it
    pkill -f "rofi -dmenu"
else
    # If Rofi is not running, start cliphist with rofi in dmenu mode
    cliphist list | rofi -dmenu | cliphist decode | wl-copy
fi
