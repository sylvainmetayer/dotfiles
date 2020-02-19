#!/usr/bin/env bash

epsi-network-vbox() {
    echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null
    flush-iptables
    
    sudo iptables -A FORWARD -o enp0s31f6 -i vboxnet1 -s 192.200.0.0/24 -m conntrack --ctstate NEW -j ACCEPT
    echo "Parameters for network project OK !"
    
    sudo iptables -A FORWARD -o enp0s31f6 -i vboxnet0 -s 192.168.56.0/24 -m conntrack --ctstate NEW -j ACCEPT
    echo "Parameters for backup project OK"
    sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A POSTROUTING -t nat -j MASQUERADE
    sudo iptables -L
}
