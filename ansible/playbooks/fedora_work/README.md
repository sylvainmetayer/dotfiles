# Fedora work

This playbook is similar with `fedora` playbook but add a role `fedora_work` which contains specific tasks required for company computer.

You **need** to encrypt `$HOME/dotfiles/ansible/roles/fedora_work/templates/ssh_hosts.j2` file as it contains sensitive data.

- view file : `ansible-vault view $HOME/dotfiles/ansible/roles/fedora_work/templates/ssh_hosts.j2`
- edit file : `ansible-vault edit $HOME/dotfiles/ansible/roles/fedora_work/templates/ssh_hosts.j2`
- encrypt file : `ansible-vault encrypt $HOME/dotfiles/ansible/roles/fedora_work/templates/ssh_hosts.j2`

To run the playbook and allow ansible to decrypt the file, you need to specify a **non versionned** file containing the password. Use the following command : `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt ansible-playbook ansible/playbooks/fedora_work/main.yml -K` after you created the file `~/.ansible_vault.txt` containing your password
