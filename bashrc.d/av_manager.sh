#!/usr/bin/env bash

av_stop() {
    sudo systemctl stop sav-protect
    sudo systemctl stop sav-rms
    sudo systemctl stop sav-update
}

av_start() {
    sudo systemctl start sav-protect
    sudo systemctl start sav-rms
    sudo systemctl start sav-update
}

av_disable() {
    sudo systemctl disable sav-protect
    sudo systemctl disable sav-rms
    sudo systemctl disable sav-update
}

av_enable() {
    sudo systemctl enable sav-protect
    sudo systemctl enable sav-rms
    sudo systemctl enable sav-update
}
