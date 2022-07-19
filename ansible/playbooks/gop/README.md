# GOP

This playbook is similar with `fedora` playbook but add a role `gop` which contains specific tasks required for company computer.

You **need** to encrypt `$HOME/dotfiles/ansible/roles/gop/templates/{ssh_hosts,aws_config}.j2` files as it contains sensitive data.

- `./scripts/extract-secrets.sh DATABASE_LOCATION` to extract the password and interact with the data inside the vault. It will be stored in `~/.ansible_vault_password.txt`

Then you can do the following :

`FILE=$HOME/dotfiles/ansible/roles/gop/templates/aws_config.j2` or `FILE=$HOME/dotfiles/ansible/roles/gop/templates/ssh_hosts.j2`

- view file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault view $FILE`
- edit file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault edit $FILE`
- encrypt file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault encrypt $FILE`
- decrypt file: `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault decrypt $FILE`

Use the following command : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook ansible/playbooks/gop/main.yml -K` to run the playbook and decrypt the files.
