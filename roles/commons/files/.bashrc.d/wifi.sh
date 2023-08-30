#!/usr/bin/env bash

qr_code_wifi() {
  qrencode -o wifi.png "WIFI:T:WPA;S:$1;P:$2;;"
}

