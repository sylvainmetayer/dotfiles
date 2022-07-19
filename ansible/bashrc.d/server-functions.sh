#!/usr/bin/env bash

flush-iptables() {
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -F
    sudo iptables -X
    sudo iptables -t nat -F
    sudo iptables -t nat -X
    sudo iptables -t mangle -F
    sudo iptables -t mangle -X
    sudo iptables -t raw -F
    sudo iptables -t raw -X
}

# Add a SSH key which can be used as deploy key with GitHub.
# It also add an entry in ssh's user config so the ssh key can be used without conflict with others keys.

addDeployKey() {
    if test $# -ne 2; then
        echo "This script is used to generate SSH keys which could be used as deploy keys with GitHub"
        echo "Usage : $0 KeyLabel key_name"
        exit 1
    fi

    echo "I will generate '$(whoami)@$1' located at /home/$(whoami)/.ssh/github_$2"
    echo -n "Is this OK ? (enter to continue, ctrl c to cancel)"
    read -r _

    ssh-keygen -t rsa -b 4096 -C "$(whoami)@$1" -f ~/.ssh/"github_$2"

    cat <<EOT >>~/.ssh/config

Host github.com_$2
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_$2
EOT

    echo "To use this key, remember to replace github.com with github.com_$2 in your git url !"
}

requestCertificate() {
    sudo certbot certonly --rsa-key-size 4096 --webroot -w /var/www/acme-challenges/ -d "$1"
}


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

# shellcheck disable=SC2048
# shellcheck disable=SC2086

runAs() {
    sudo -u www-data $*
}

