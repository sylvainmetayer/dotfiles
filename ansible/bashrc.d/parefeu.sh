#!/usr/bin/env bash

#Enable the firewall and set custom rules.
# /!\ Test it before use, or you can be locked out of your own server !
# - require `iptables`

parefeu() {    
    sudo iptables -t filter -F
    sudo iptables -t filter -X
    
    sudo iptables -t filter -P INPUT DROP
    sudo iptables -t filter -P FORWARD DROP
    sudo iptables -t filter -P OUTPUT DROP
    echo "[DENY ALL]"
    
    sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    echo "Allow established connections"
    
    sudo iptables -t filter -A INPUT -i lo -j ACCEPT
    sudo iptables -t filter -A OUTPUT -o lo -j ACCEPT
    echo "Allow loopback"
    
    sudo iptables -t filter -A INPUT -p icmp -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p icmp -j ACCEPT
    echo "Allow ping"
    
    sudo iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
    echo "Allow SSH"
    
    sudo iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
    sudo iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
    sudo iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
    echo "Allow DNS"
    
    sudo iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
    echo "Allow NTP"
    
    sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT
    echo "Allow HTTP/HTTPS"
    
    sudo iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
    sudo iptables -t filter -A INPUT -p tcp --dport 587 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 587 -j ACCEPT
    echo "Allow SMTP on port 25/587"
    
    sudo iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
    echo "Allow POP3 on port 110"
    
    sudo iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
    echo "trafic IMAP sur le port 143 autorisé"
    
    sudo iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
    echo "Allow POP3S on port 995"
    
    echo "Firewall set !"
}