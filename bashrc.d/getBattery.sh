#!/usr/bin/env bash

# Return battery informations.

getBattery() {
    upower -i /org/freedesktop/UPower/devices/battery_BAT0
}
