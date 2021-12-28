# Fedora work

This playbook is similar with `fedora` playbook but add a role `fedora_work` which contains specific tasks required for company computer.

You **need** to encrypt `$HOME/dotfiles/ansible/roles/fedora_work/templates/{ssh_hosts,aws_config}.j2` files as it contains sensitive data.

To run the playbook and allow ansible to decrypt the file, you need to specify a **non versionned** file containing the password. First, create a file in `~/.ansible_vault.txt` with your password.

Then you can do the following :

`FILE=$HOME/dotfiles/ansible/roles/fedora_work/templates/aws_config.j2` or `FILE=$HOME/dotfiles/ansible/roles/fedora_work/templates/ssh_hosts.j2`

- view file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault view $FILE`
- edit file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault edit $FILE`
- encrypt file : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault encrypt $FILE`
- decrypt file: `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-vault decrypt $FILE`

 Use the following command : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook ansible/playbooks/fedora_work/main.yml -K` to run the playbook and decrpyt the files.
