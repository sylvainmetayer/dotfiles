#!/usr/bin/env bash

alias gpg='gpg2'
alias getBattery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias getclip='xclip -selection c -o'
alias setclip='xclip -selection c'
alias showLastAccess='sudo tail -n 10 /var/log/nginx/*.access.log'
alias showLastError='sudo tail -n 10 /var/log/nginx/*.error.log'
alias t_get='gsettings get org.gnome.desktop.peripherals.touchpad send-events'
alias k='kubectl'
complete -o default -F __start_kubectl k
alias cookieFortune='cowsay -f $(cowsay -l | tail -n +2 | xargs | tr " " "\n" | shuf -n 1) $(fortune)'
alias urldecode='python3 -c "import sys, urllib.parse as ul;print(ul.unquote_plus(sys.argv[1]))"'
