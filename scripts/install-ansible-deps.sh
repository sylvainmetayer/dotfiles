#!/usr/bin/env bash

if [[ -z $PIPENV_ACTIVE ]]; then
    echo "Pipenv not detected, install deps"
    pip install pipenv --user
    pipenv install
fi

pipenv run ansible-galaxy role install -r "$HOME/dotfiles/requirements.yml"
pipenv run ansible-galaxy collection install -r "$HOME/dotfiles/requirements.yml"
