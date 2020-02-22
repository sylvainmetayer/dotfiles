# dotfiles
🔧 🏠 WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![CircleCI](https://circleci.com/gh/sylvainmetayer/dotfiles.svg?style=svg)](https://circleci.com/gh/sylvainmetayer/dotfiles)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/CI/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)

## Setup

- `dnf install ansible git`
- `git clone git@github.com:sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `cp $HOME/dotfiles/variables.yml.sample $HOME/dotfiles/variables.yml && vim $HOME/dotfiles/variables.yml`
- `ansible-galaxy install -r $HOME/dotfiles/requirements.yml`
- `ANSIBLE_CONFIG=$HOME/dotfiles/ansible.cfg ansible-playbook -i $HOME/dotfiles/inventory.yml $HOME/dotfiles/fedora.yml --extra-vars "@$HOME/dotfiles/variables.yml" -K`

If network is unreachable, you can run the following commands to skip network related tasks (such as downloading packages). Beware that this could lead to errors if programms are not installed.

- `ANSIBLE_CONFIG=$HOME/dotfiles/ansible.cfg ansible-playbook -i $HOME/dotfiles/inventory.yml $HOME/dotfiles/fedora.yml --extra-vars "@$HOME/dotfiles/variables.yml" -K --skip-tags network_access`

## GPG Keys

If you want to import a GPG key and set it as your Git signing key to sign your commits, import it **before** starting the playbook with the following command : 

> `gpg --import key.asc`

Then, get the fingerprint of the wanted key with  `gpg --list-secret-keys --keyid-format LONG` and set this value as `git_key` in the `variables.yml` file.


## Debug facts

> `ansible localhost -m setup > $HOME/dotfiles/debug.json`

## Update

A script `dotfiles_update` is provided for easier update.

## SSH Configuration

Put any local SSH settings in `$HOME/.ssh_config` folder.