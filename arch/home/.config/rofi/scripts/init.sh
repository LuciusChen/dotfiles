#!/bin/bash

# Check if Rofi is running in dmenu mode
if pgrep -f "rofi -dmenu" > /dev/null; then
    # If Rofi is running, kill it
    pkill -f "rofi -dmenu"
    rofi -show drun -show-icons
elif pgrep -x "rofi" > /dev/null; then
    # If Rofi is running in drun mode, kill it
    pkill -x "rofi"
else
    # If Rofi is not running, start it in drun mode
    rofi -show drun -show-icons
fi
