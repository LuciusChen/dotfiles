#!/bin/bash

if ps aux | grep "[x]wayland-satellite" > /dev/null
then
    echo "xwayland-satellite is already running.111"
else
    echo "Starting xwayland-satellite..."
    xwayland-satellite &
    sleep 1
fi

/opt/wechat/wechat
