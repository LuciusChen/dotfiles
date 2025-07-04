#!/bin/bash

start_waybar() {
  waybar &> /tmp/waybar_log.txt &
}

start_waybar

running_time=0

while true; do
  sleep 5
  if pgrep -x "waybar" > /dev/null; then
    running_time=$((running_time + 5))
    if [ $running_time -ge 60 ]; then
      exit 0
    fi
  else
    running_time=0
    start_waybar
  fi
done
