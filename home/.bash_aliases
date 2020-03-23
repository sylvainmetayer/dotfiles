#!/usr/bin/env bash

alias gpg='gpg2'
alias update_dotfiles='ANSIBLE_CONFIG=$HOME/dotfiles/ansible.cfg ansible-playbook -i $HOME/dotfiles/inventory.yml $HOME/dotfiles/fedora.yml --extra-vars "@$HOME/dotfiles/variables.yml" -K --ask-vault-pass'
alias getBattery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias getclip='xclip -selection c -o'
alias setclip='xclip -selection c'
alias showLastAccess='sudo tail -n 10 /var/log/nginx/*.access.log'
alias showLastError='sudo tail -n 10 /var/log/nginx/*.error.log'
alias t_get='gsettings get org.gnome.desktop.peripherals.touchpad send-events'
alias k='kubectl'
alias cookieFortune='cowsay -f $(cowsay -l | tail -n +2 | xargs | tr " " "\n" | shuf -n 1) $(fortune)'
