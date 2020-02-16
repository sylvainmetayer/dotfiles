# dotfiles
🔧 🏠 WIP

## Setup

- `dnf install ansible git`
- `git clone git@github.com:sylvainmetayer/dotfiles.git $HOME/dotfiles`
- `ansible-galaxy install -r $HOME/dotfiles/requirements.yml`
- `ANSIBLE_CONFIG=$HOME/dotfiles/ansible.cfg ansible-playbook -i $HOME/dotfiles/inventory.yml $HOME/dotfiles/fedora.yml --extra-vars "@$HOME/dotfiles/variables.yml" -K`

If network is unreachable, you can run the following commands to skip network related tasks (such as downloading packages). Beware that this could lead to errors if programms are not installed.

- `ANSIBLE_CONFIG=$HOME/dotfiles/ansible.cfg ansible-playbook -i $HOME/dotfiles/inventory.yml $HOME/dotfiles/fedora.yml --extra-vars "@$HOME/dotfiles/variables.yml" -K --skip-tags network_access`

> Debug facts
>
> `ansible localhost -m setup > $HOME/dotfiles/debug.json`


## SSH Configuration

Put any local SSH settings in `$HOME/.ssh_config` folder.