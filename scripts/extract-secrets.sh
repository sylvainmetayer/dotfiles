#!/usr/bin/env bash

usage() {
    echo "Usage : $0 database.kdbx"
    echo "Require: keepassxc-cli"
}

if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

keepassxc-cli show -a password -s "$1" /dotfiles/work_vault_password > ~/.ansible_vault.txt
