#!/usr/bin/env bash

# TODO Extract vault password into home directory

# https://snarky.ca/why-you-should-use-python-m-pip/
python3 -m pip install --user -r "$HOME/dotfiles/requirements.txt"
ansible-galaxy role install -r "$HOME/dotfiles/ansible/requirements.yml"
ansible-galaxy collection install -r "$HOME/dotfiles/ansible/requirements.yml"
