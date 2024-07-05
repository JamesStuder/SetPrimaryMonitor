#!/bin/bash

LOGFILE="/var/log/set_primary_monitor.log"
echo "Script run at: $(date)" > $LOGFILE

# Detect session type
if [[ $WAYLAND_DISPLAY ]]; then
    session_type="wayland"
elif [[ $DISPLAY ]]; then
    session_type="x11"
else
    session_type="unsupported"
fi

echo "Detected session type: $session_type" >> $LOGFILE

# Function to turn off all external monitors (X11)
turn_off_external_monitors_x11() {
    primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
    if [ -z "$primary_monitor" ]; then
        primary_monitor=$(xrandr --query | grep " connected" | head -n 1 | cut -d" " -f1)
    fi
    echo "Primary monitor (X11): $primary_monitor" >> $LOGFILE

    for output in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if [ "$output" != "$primary_monitor" ]; then
            xrandr --output "$output" --off
            echo "Turned off monitor (X11): $output" >> $LOGFILE
        else
            xrandr --output "$output" --auto
            echo "Ensured primary monitor is on (X11): $output" >> $LOGFILE
        fi
    done
}

# Function to set primary monitor (X11)
set_primary_monitor_x11() {
    primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
    if [ -z "$primary_monitor" ]; then
        primary_monitor=$(xrandr --query | grep " connected" | head -n 1 | cut -d" " -f1)
    fi
    xrandr --output "$primary_monitor" --primary --auto
    echo "Set primary monitor (X11): $primary_monitor" >> $LOGFILE
    turn_off_external_monitors_x11
}

# Function to turn off all external monitors (Wayland)
turn_off_external_monitors_wayland() {
    primary_monitor=$(kwayland-integration --list-outputs | grep -oP '(?<=Name: ).*' | head -n 1)
    outputs=$(kwayland-integration --list-outputs | grep -oP '(?<=Name: ).*')
    echo "Primary monitor (Wayland): $primary_monitor" >> $LOGFILE

    for output in $outputs; do
        if [ "$output" != "$primary_monitor" ]; then
            kwayland-integration --disable-output "$output"
            echo "Turned off monitor (Wayland): $output" >> $LOGFILE
        else
            kwayland-integration --enable-output "$output"
            echo "Ensured primary monitor is on (Wayland): $output" >> $LOGFILE
        fi
    done
}

# Function to set primary monitor (Wayland)
set_primary_monitor_wayland() {
    primary_monitor=$(kwayland-integration --list-outputs | grep -oP '(?<=Name: ).*' | head -n 1)
    kwayland-integration --set-primary "$primary_monitor"
    kwayland-integration --enable-output "$primary_monitor"
    echo "Set primary monitor (Wayland): $primary_monitor" >> $LOGFILE
    turn_off_external_monitors_wayland
}

# Apply settings based on the detected session type
if [ "$session_type" = "x11" ]; then
    set_primary_monitor_x11
elif [ "$session_type" = "wayland" ]; then
    set_primary_monitor_wayland
else
    echo "Unsupported session type: $session_type" >> $LOGFILE
    exit 1
fi
