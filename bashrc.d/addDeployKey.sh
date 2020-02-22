#!/usr/bin/env bash

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
