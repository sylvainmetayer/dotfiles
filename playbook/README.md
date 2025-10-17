## Playbook directory

Ce dossier contient les playbooks principaux de provisioning des différentes machines.

Convention de nommage : `setup-<host>.yaml` où `<host>` correspond à l'entrée dans `inventory.yml`.

Variables spécifiques non sensibles : `host_vars/<host>.yaml`.
Variables sensibles ou chiffrées : rester dans les anciens `playbooks/<host>/locals.yml` (GOP chiffré).

Pour l'exécution :

```bash
pipenv run ansible-playbook playbook/setup-dell.yaml -K --extra-vars="ansible_python_interpreter=$(pipenv --venv)/bin/python"
```

Voir le `README.md` racine pour plus de détails.
