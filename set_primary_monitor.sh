#!/bin/bash

# Hard-coded laptop monitor identifier
laptop_monitor="eDP-1"

# Turn on the laptop monitor and set it as primary
xrandr --output "$laptop_monitor" --primary --auto

# Turn off all other monitors
for output in $(xrandr | grep " connected" | cut -d" " -f1); do
    if [ "$output" != "$laptop_monitor" ]; then
        xrandr --output "$output" --off
    fi
done
