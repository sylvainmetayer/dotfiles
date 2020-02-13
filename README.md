# dotfiles
🔧 🏠 WIP

## Setup

- `dnf install ansible git`

- `git clone $HOME/dotfiles`

- `ansible-galaxy install -r $HOME/dotfiles/requirements.yml`
- `ansible-playbook -i $HOME/dotfiles/inventory $HOME/dotfiles/fedora.yml -K`

> Debug facts
>
> `ansible localhost -m setup > $HOME/dotfiles/debug.json`