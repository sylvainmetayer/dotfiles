#!/usr/bin/env bash

python3 -m pip install --user -r "$HOME/dotfiles/requirements.txt"
ansible-galaxy role install -r "$HOME/dotfiles/ansible/requirements.yml"
ansible-galaxy collection install -r "$HOME/dotfiles/ansible/requirements.yml"
