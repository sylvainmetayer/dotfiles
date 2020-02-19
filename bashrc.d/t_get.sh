#!/usr/bin/env bash

# Return the state of the touchpad (enabled/disabled)
# - Gnome only


t_get() {
    gsettings get org.gnome.desktop.peripherals.touchpad send-events
}

