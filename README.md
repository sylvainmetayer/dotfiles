# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Terraform/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)
[![Github Action](https://github.com/sylvainmetayer/dotfiles/workflows/Lint/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions)

## Initial Setup

- `dnf install git keepassxc python3-pip`
- `git clone https://github.com/sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `./scripts/install-ansible-deps.sh`
- If you want autocomplete
  - `activate-global-python-argcomplete --dest ~/.bashrc.d/`
  - `chmod +x ~/.bashrc.d/python-argcomplete`

## Usage

### Playbooks (nouvelle structure)

Les playbooks sont maintenant aplatis dans le dossier `playbook/` à la racine pour simplifier l'exécution. Chaque machine possède un fichier `setup-<host>.yaml`.

| Machine | Fichier | Commande |
|---------|---------|----------|
| Dell (Fedora perso) | `playbook/setup-dell.yaml` | `pipenv run ansible-playbook playbook/setup-dell.yaml -K --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"` |
| Home (Fedora desktop) | `playbook/setup-home.yaml` | `pipenv run ansible-playbook playbook/setup-home.yaml -K --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"` |
| GOP (Laptop entreprise) | `playbook/setup-gop.yaml` | `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt pipenv run ansible-playbook playbook/setup-gop.yaml -K --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"` |
| WSL (Debian sous Windows) | `playbook/setup-wsl.yaml` | `pipenv run ansible-playbook playbook/setup-wsl.yaml --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"` |

Pour récupérer la valeur `SSH_AUTH_SOCK` (utile pour KeepassXC) : `systemctl status --user ssh-agent` puis configurer KeepassXC avec ce socket.

### GOP (vault / secrets)

Le playbook GOP ajoute le rôle `gop` contenant des tâches spécifiques. Certains fichiers sont chiffrés via Ansible Vault. Gestion des outils (ex plugins) désormais via `mise_global_plugins` dans `host_vars`.

Pré-requis :

1. Base de données `selfhosted.kdbx` disponible (sinon la télécharger depuis <https://r.sylvain.dev/dotfiles-database>).
2. Exécuter `./scripts/extract-secrets.sh DATABASE_LOCATION` pour extraire le mot de passe (stocké dans `~/.ansible_vault_password.txt`).

Fichiers sensibles :

```bash
FILE=$HOME/dotfiles/roles/gop/templates/aws_config.j2
FILE=$HOME/dotfiles/roles/gop/templates/ssh_hosts.j2
FILE=$HOME/dotfiles/playbooks/gop/locals.yml
```

Opérations Vault :

```bash
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault view $FILE
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault edit $FILE
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault encrypt $FILE
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault decrypt $FILE
```

Exécution :

```bash
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt pipenv run ansible-playbook playbook/setup-gop.yaml -K --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"
```

## TODO

- [ ] Fedora 39 - enable rpmfusion repository
- [ ] Fix errors with psutils when running with pipenv

## Ansible Galaxy

### Build

- `ansible-galaxy collection build`

### Publish

- `ansible-galaxy collection publish sylvainmetayer-workstation-1.0.0.tar.gz --token TOKEN`
