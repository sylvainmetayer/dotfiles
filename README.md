# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/CI/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Lint/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)

## Setup

- `dnf install ansible git`
- `git clone git@github.com:sylvainmetayer/dotfiles.git $HOME/dotfiles`
- Create a [Github Token](https://github.com/settings/tokens) with `user` and `admin:public_key` scopes
- `cp $HOME/dotfiles/ansible/variables.yml.sample $HOME/dotfiles/ansible/variables.yml && vim $HOME/dotfiles/ansible/variables.yml`
- `ansible-galaxy install -r $HOME/dotfiles/ansible/requirements.yml`
- `ansible-playbook ansible/playbooks/PLAYBOOK_NAME/main.yml -K`

## Ansible playbooks

### Fedora

On a new fedora workstation, setup custom apps and config.

### Fedora work

Similar as the `fedora playbook` with some modifications required for work.

### Gibbs

- Playbook to setup apps on a hosted VPS.

## Debug facts

> `ansible localhost -m setup > $HOME/dotfiles/debug.json`

<details>
<summary>Additionnal details</summary>

## GPG Keys

If you want to import a GPG key and set it as your Git signing key to sign your commits, import it **before** starting the playbook with the following commands :

- `gpg --import key.asc`
- `gpg --update-trustdb`

Then, get the fingerprint of the wanted key with `gpg --list-secret-keys --keyid-format LONG` and set this value as `git_key` in the `variables.yml` file.

</details>
