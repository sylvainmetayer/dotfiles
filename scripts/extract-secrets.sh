#!/usr/bin/env bash

usage() {
    echo "Usage : $0 database.kdbx"
    echo "Require: keepassxc-cli"
}

if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

# The vault password must not be readable by other accounts (Fedora umask: 0022, file in 0644).
# umask covers a new file, chmod an existing one (> keeps its mode), before the password is written.
umask 077
[[ ! -e ~/.ansible_vault.txt ]] || chmod 600 ~/.ansible_vault.txt
keepassxc-cli show -a password -s "$1" /dotfiles/work_vault_password > ~/.ansible_vault.txt
