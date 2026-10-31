## Playbook directory

Ce dossier contient les playbooks principaux de provisioning des différentes machines.

Convention de nommage : `setup-<host>.yaml` où `<host>` correspond à l'entrée dans `inventory.yml`.

Variables spécifiques non sensibles : `host_vars/<host>.yaml`.
Variables sensibles ou chiffrées : `host_vars/<host>/vault.yml` (chiffré Ansible Vault, cf. `host_vars/gop/`) ou `host_vars/<host>.sops.yaml` (SOPS/age, cf. `host_vars/home.sops.yaml`, lu par les rôles qui en ont besoin).

Pour l'exécution (venv activé par mise ; `ansible.cfg` fixe déjà l'interpréteur des modules) :

```bash
ansible-playbook playbook/setup-dell.yaml -K
```

Voir le `README.md` racine pour plus de détails.
