#!/bin/bash

# Function to start Dropbox
start_dropbox() {
  pkill dropbox
  ~/.dropbox-dist/dropboxd &
  sleep 2 # Wait for Dropbox to initialize
}

# Function to start Waybar
start_waybar() {
  waybar &
}

# Try to start Waybar
start_waybar

# Check if Waybar crashed and restart if necessary
while true; do
  sleep 5 # Check every 5 seconds
  if ! pgrep -x "waybar" > /dev/null; then
    echo "Waybar crashed, restarting Dropbox and Waybar..."
    start_dropbox
    start_waybar
  fi
done
