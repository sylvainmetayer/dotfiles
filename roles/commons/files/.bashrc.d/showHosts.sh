#!/usr/bin/env bash

# Show the available hostname of your ssh configuration.

showHosts() {
    ssh_file=~/.ssh/config
    
    if ! test -f "$ssh_file"; then
        echo "Their is no ssh config"
        exit 1
    fi
    
    echo "SSH Hosts :"
    grep -E "^Host .*" "$ssh_file" | sed  's/Host \(.*\)/\1/'
}