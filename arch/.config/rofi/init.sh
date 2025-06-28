#!/bin/bash

# Check if Rofi is running
if pgrep -x "rofi" > /dev/null; then
    # If Rofi is running, kill it
    pkill -x "rofi"
else
    # If Rofi is not running, start it
    rofi -show drun
fi
