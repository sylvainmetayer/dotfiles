# obsidian_config

Seeds the stable `.obsidian` settings of a vault (app, daily notes, templates, community plugins) and the
remotely-save settings, always with `force: false`: an existing file is never overwritten.

Connection details of remotely-save (WebDAV address, user, remote folder) come from a sops-encrypted vars
file, `host_vars/<host>.sops.yaml`, decrypted with the age key of the workstation (`sops host_vars/home.sops.yaml` to edit).
The password is never managed: it stays empty in the seed and is typed once in Obsidian, which then re-saves
the file obfuscated. The plugin itself is installed from Obsidian, not by this role.

See `defaults` folder for available variables and playbook linked in collection for usage.
