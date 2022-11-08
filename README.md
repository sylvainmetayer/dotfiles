# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Terraform/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Lint/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
![Cron status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/kYvRrGbV/cron.svg)
![Backup status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/KhnZCMHl/backup.svg)

## Initial Setup

- `dnf install git keepassxc python3-pip`
- `git clone https://github.com/sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `./scripts/install-ansible-deps.sh`
- If you want autocomplete
  - `activate-global-python-argcomplete --dest ~/.bashrc.d/`
  - `chmod +x ~/.bashrc.d/python-argcomplete`

## Usage

### Dell

My personal laptop, running Fedora.

- `ansible-playbook playbooks/dell/main.yaml -K`
- `systemctl status --user ssh-agent` to get the `SSH_AUTH_SOCK` value
  - Configure KeepassXC to use this socket

### GOP

This playbook is similar with `dell` playbook but add a role `gop` which contains specific tasks required for company computer.

You **need** to encrypt some files as it contains sensitive data.

- Ensure the `selfhosted.kdbx` database is available
  - If needed, you can download it from <https://r.sylvain.dev/dotfiles-database>
- `./scripts/extract-secrets.sh DATABASE_LOCATION` to extract the password and interact with the data inside the vault. It will be stored in `~/.ansible_vault_password.txt`

Then you can do the following :

- `FILE=$HOME/dotfiles/roles/gop/templates/aws_config.j2`
- `FILE=$HOME/dotfiles/roles/gop/templates/ssh_hosts.j2`
- `FILE=$HOME/dotfiles/playbooks/gop/locals.yml`

- view file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault view $FILE`
- edit file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault edit $FILE`
- encrypt file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault encrypt $FILE`
- decrypt file: `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault decrypt $FILE`

Use the following command : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook playbooks/gop/main.yml -K` to run the playbook and decrypt the files.

## Ansible Galaxy

### Build

- `ansible-galaxy collection build`

### Publish

- `ansible-galaxy collection publish sylvainmetayer-workstation-1.0.0.tar.gz --token TOKEN`
