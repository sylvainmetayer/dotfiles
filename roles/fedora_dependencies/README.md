# fedora_dependencies

See `defaults` folder for available variables and playbook linked in collection for usage.

## SELinux : permissif

Décision du 2026-11-13 : SELinux reste en mode **permissif** sur les trois postes (`dell`, `gop`, `home`).

- **Ce que fait la variable** : `fedora_dependencies_disable_selinux: true` (défaut depuis 2022) exécute `tasks/selinux.yaml`, qui passe la politique `targeted` en `permissive` (via `ansible.posix.selinux`). SELinux n'est donc pas désactivé : il journalise les refus sans les appliquer. Le nom est trompeur, il n'a pas été renommé. À `false`, la tâche est sautée : le rôle ne remet jamais SELinux en enforcing.
- **Pourquoi** : ce défaut n'a jamais été justifié depuis 2022 et l'enforcing n'a pas été essayé. Casseurs soupçonnés en enforcing, **non vérifiés** : xremap, la clé de fichier LUKS, les overrides flatpak.
- **Pour revoir ce choix** : `sudo setenforce 1` (valable jusqu'au redémarrage), utiliser le poste normalement, puis `sudo ausearch -m avc -ts recent` pour lister les refus. Si tout est propre, passer la variable à `false` et configurer SELinux en enforcing hors du rôle.
