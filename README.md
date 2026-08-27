# dotfiles

🔧 🏠 Always WIP

[![https://www.shellcheck.net/](https://img.shields.io/badge/%F0%9F%9B%A1-ShellCheck-brightgreen.svg)](https://www.shellcheck.net/)
[![Ansible](https://github.com/sylvainmetayer/dotfiles/actions/workflows/ansible.yml/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions/workflows/ansible.yml)
[![Ansible Lint](https://github.com/sylvainmetayer/dotfiles/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions/workflows/ansible-lint.yml)
[![Lint](https://github.com/sylvainmetayer/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/sylvainmetayer/dotfiles/actions/workflows/lint.yml)

## Initial Setup

- `dnf install git`
- [Installer mise](https://mise.jdx.dev/getting-started.html)
- `git clone https://github.com/sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `cd $HOME/dotfiles && mise trust && mise install`
- Optionnel, pour l'autocomplétion des commandes ansible :
  - `activate-global-python-argcomplete --dest ~/.bashrc.d/`
  - `chmod +x ~/.bashrc.d/python-argcomplete`

`mise` installe `uv` et Python, et active automatiquement le virtualenv `.venv` (dépendances déclarées dans `pyproject.toml`).

Les rôles et collections Galaxy s'installent avec :

```bash
mise run install
```

## Usage

### Playbooks

Les playbooks sont aplatis dans le dossier `playbook/` à la racine. Chaque machine possède un fichier `setup-<host>.yaml` correspondant à une entrée de `inventory.yml`.

| Machine | Fichier | Commande |
|---------|---------|----------|
| Dell (Fedora perso) | `playbook/setup-dell.yaml` | `ansible-playbook playbook/setup-dell.yaml -K` |
| Home (Fedora desktop) | `playbook/setup-home.yaml` | `ansible-playbook playbook/setup-home.yaml -K` (ou `mise run home`) |
| GOP (Laptop entreprise) | `playbook/setup-gop.yaml` | `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook playbook/setup-gop.yaml -K` |

Chaque rôle est associé à un tag, ce qui permet de rejouer une partie seulement :

```bash
ansible-playbook playbook/setup-home.yaml -K --tags gnome
```

Variables non sensibles par machine : `host_vars/<host>.yaml`. Variables partagées : `group_vars/all.yaml`.

Pour récupérer la valeur `SSH_AUTH_SOCK` (utile pour KeepassXC) : `systemctl status --user ssh-agent` puis configurer KeepassXC avec ce socket.

### Lint

```bash
mise run lint      # ansible-lint
mise run lint-fix  # ansible-lint --fix
yamllint .
```

### GOP (vault / secrets)

Le playbook GOP ajoute le rôle `gop` contenant des tâches spécifiques. Certains fichiers sont chiffrés via Ansible Vault. Gestion des outils (ex plugins) désormais via `mise_global_plugins` dans `host_vars`.

Pré-requis :

1. Base de données `selfhosted.kdbx` disponible (sinon la télécharger depuis <https://r.sylvain.dev/dotfiles-database>).
2. Exécuter `./scripts/extract-secrets.sh DATABASE_LOCATION` pour extraire le mot de passe (stocké dans `~/.ansible_vault.txt`).

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
ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook playbook/setup-gop.yaml -K
```

## Ansible Galaxy

La publication de la collection `sylvainmetayer.workstation` est automatique : un push sur `main` déclenche le workflow `Deploy Collection`, qui incrémente la version dans `galaxy.yml` puis build et publie sur Galaxy.

Manuellement :

```bash
ansible-galaxy collection build
ansible-galaxy collection publish sylvainmetayer-workstation-<version>.tar.gz --token TOKEN
```
