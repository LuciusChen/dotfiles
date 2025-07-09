#!/bin/bash

if bluetoothctl show | grep 'Powered: no' -q; then
    bluetoothctl power on
else
    bluetoothctl power off
fi
