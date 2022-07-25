#!/usr/bin/env bash

# https://snarky.ca/why-you-should-use-python-m-pip/
if [ -n "$VIRTUAL_ENV" ]; then
    python3 -m pip install -r "$HOME/dotfiles/requirements.txt"
else
    python3 -m pip install --user -r "$HOME/dotfiles/requirements.txt"
fi
ansible-galaxy role install -r "$HOME/dotfiles/requirements.yml"
ansible-galaxy collection install -r "$HOME/dotfiles/requirements.yml"
