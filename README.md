# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Ansible/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Terraform/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Lint/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
![Cron status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/kYvRrGbV/cron.svg)
![Backup status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/KhnZCMHl/backup.svg)

## Initial Setup

- `dnf install git keepassxc`
- `git clone https://github.com/sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `python3 -m pip install --user -r requirements.txt`
- Ensure the `selfhosted.kdbx` database is available
  - If needed, you can download it from <https://r.sylvain.dev/dotfiles-database>
- `./scripts/install-ansible-deps.sh`

## Usage

### Dell

My personal laptop, running Fedora.

- `ansible-playbook ansible/playbooks/dell/main.yaml -K`
- `systemctl status --user ssh-agent` to get the `SSH_AUTH_SOCK` value
  - Configure KeepassXC to use this socket

## Terraform

State is stored on Terraform cloud.

```bash
asdf install
```

### Prerequisite

Before running any terraform command, you need to source some environnement variables (see `params/.env.sample` for reference)

You should keep a copy of your env files on a non versionned place.

Example

```bash
ln -s ~/kDrive/Backups/config/env.dotfiles params/.env
```

Then before running any terraform command, use the `load_env` function to load environnement variables.

A `.env` file symlink is available in `terraform` folder and reference a `.env` in `params`

### Setup infra

- `terraform login`
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform [plan|target] --target=module.XXX` where `module.xxx` is the module you want to deploy

### Lock providers

`terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64`
