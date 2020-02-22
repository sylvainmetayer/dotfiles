#!/usr/bin/env bash

# Configure Network Access on VirtualBox.
# - Require configuration inside the script to match your needs.

configureNetwork() {
    VBOX_NETWORK=("vboxnet1 192.200.0.0/24" "vboxnet0 192.168.56.0/24")
    NETWORK_INTERFACE=wlp2s0

    echo "Will configure network for the following vbox interface(s) (on ${NETWORK_INTERFACE})"
    echo "This won't survive a reboot"

    for item in "${VBOX_NETWORK[@]}"; do
        network=$(echo "$item" | cut -d" " -f 2)
        interface=$(echo "$item" | cut -d" " -f 1)
        echo "- ${interface} - ${network}"
    done

    echo "Ctrl-C to cancel, enter to proceed"
    read -r _

    echo "Enable ip_forward"
    echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

    for item in "${VBOX_NETWORK[@]}"; do
        network=$(echo "$item" | cut -d" " -f 2)
        interface=$(echo "$item" | cut -d" " -f 1)
        sudo iptables -A FORWARD -o "$NETWORK_INTERFACE" -i "$interface" -s "$network" -m conntrack --ctstate NEW -j ACCEPT
        echo "- ${interface} - ${network}"
    done

    sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A POSTROUTING -t nat -j MASQUERADE

}
