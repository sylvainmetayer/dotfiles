#!/usr/bin/env bash

# Disable the firewall. Set default rules to ACCEPT.
# - require `iptables`




openbar() {
    sudo iptables -t filter -F
    sudo iptables -t filter -X
    sudo iptables -t filter -P INPUT ACCEPT
    sudo iptables -t filter -P FORWARD ACCEPT
    sudo iptables -t filter -P OUTPUT ACCEPT
    echo "[ALLOW ALL]"
    echo "Firewall disabled !"
}