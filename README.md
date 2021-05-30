# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Ansible/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Terraform/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Lint/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
![Cron status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/kYvRrGbV/cron.svg)
![Backup status](https://healthchecks.io/badge/7373bc4e-5131-49ce-ae55-8b7c78e28a1e/KhnZCMHl/backup.svg)

## Ansible playbooks

### Setup

- `dnf install ansible git`
- `git clone git@github.com:sylvainmetayer/dotfiles.git $HOME/dotfiles`
- Create a [Github Token](https://github.com/settings/tokens) with `user` and `admin:public_key` scopes
- `cp $HOME/dotfiles/params/variables.yml.sample $HOME/dotfiles/params/variables.yml && vim $HOME/dotfiles/params/variables.yml`
- If you already have a variables files, you can symlink it instead. `ln -s ~/kDrive/config/variables.yml params/variables.yml`
- `ansible-galaxy install -r $HOME/dotfiles/ansible/requirements.yml`
- `ansible-playbook ansible/playbooks/PLAYBOOK_NAME/main.yml -K`

### Fedora

On a new fedora workstation, setup custom apps and config.

### Fedora work

Similar as the `fedora playbook` with some modifications required for work.

### Gibbs

- Playbook to setup apps on a hosted VPS.

- You need to run the `module.gibbs` terraform module before using this playbook as it configure health check URLs for backup

### Debug facts

> `ansible localhost -m setup > $HOME/dotfiles/debug.json`

<details>
<summary>Additionnal details</summary>

## GPG Keys

If you want to import a GPG key and set it as your Git signing key to sign your commits, import it **before** starting the playbook with the following commands :

- `gpg --import key.asc`
- `gpg --update-trustdb`

Then, get the fingerprint of the wanted key with `gpg --list-secret-keys --keyid-format LONG` and set this value as `git_key` in the `variables.yml` file.

</details>

## Terraform

### Prerequisite

Before running any terraform command, you need to source some environnement variables (see `params/.env.sample` for reference)

You should keep a copy of your env files on a non versionned place.

Example

```
ln -s ~/kDrive/config/.env.dotfiles params/.env
```

Then before running any terraform command, use the `load_env` function to load environnement variables.

A `.env` file symlink is available in `terraform` and `terraform/backend` folders and reference a `.env` in `params`

### Initialize s3 backend

To be available across multiple machine, state is stored on a scaleway bucket.

You need to do this only one time

```bash
cd terraform/backend
terraform init
terraform apply
```

Once you do this, you may want to keep a backup of the `params/setup-backend.tfstate` file to avoid recreating another backend bucket and symlink it if you need to reuse it later.

- `ln -s /backups/setup-backend.tfstate ~/dotfiles/params/setup-backend.tfstate`

### Setup infra

- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform [plan|target] --target=module.XXX` where `module.xxx` is the module you want to deploy
