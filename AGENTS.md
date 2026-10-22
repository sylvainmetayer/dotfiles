# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## What this is

Ansible-based provisioning for the author's personal Fedora workstations. It is a plain dotfiles repo, not a published Galaxy collection (publishing stopped in #193). Everything runs against `ansible_connection: local` hosts (`dell`, `gop`, `home` in `inventory.yml`) — there is no remote fleet.

## Commands

Tooling is managed by **mise** (`mise.toml`), which provisions `uv` + Python and auto-activates `.venv`. Dependencies come from `pyproject.toml` via uv.

The `.venv` is the *controller* only. `ansible.cfg` pins `interpreter_python = /usr/bin/python3` so modules execute on the system interpreter, which owns the C bindings they need (`python3-libselinux`, `python3-libdnf5`, `python3-psutil`). mise's standalone Python can never provide these, and its version drifts from Fedora's — do not remove that pin or add target-runtime shims such as the `selinux` PyPI package to `pyproject.toml`.

```bash
mise run install     # ansible-galaxy role + collection install -r requirements.yml
mise run lint        # ansible-lint
mise run lint-fix    # ansible-lint --fix
mise run home        # provision the "home" host (depends on install)

ansible-playbook playbook/setup-<host>.yaml -K            # run a host playbook
ansible-playbook playbook/setup-<host>.yaml --syntax-check # what CI gates on
ansible-playbook playbook/setup-home.yaml -K --tags gnome  # run one role (every role is tagged)
yamllint .
```

There is no test suite. CI (`.github/workflows/`) runs `--syntax-check` on every `playbook/setup-*.yaml`, `ansible-lint`, `yamllint .`, and shellcheck over `roles/commons/files/.bashrc.d`.

## Architecture

**Playbooks are flat and per-host.** `playbook/setup-<host>.yaml` maps 1:1 to a host in `inventory.yml`. Each playbook is a plain list of roles, every one carrying a `tags: [<role>]` entry so individual pieces can be re-run. Non-secret per-host config lives in `host_vars/<host>.yaml`; shared config in `group_vars/all.yaml`. GOP is the only host needing secrets, so it uses a `host_vars/gop/` directory instead of a single file: `host_vars/gop/vars.yaml` (plain) plus `host_vars/gop/vault.yml` (Ansible Vault encrypted), both auto-loaded by Ansible for the `gop` host — no `pre_tasks`/`include_vars` needed. The legacy `playbooks/` (plural) directory has been dropped.

**`roles/generic_app` is the pattern for third-party apps.** Rather than one role per application, playbooks include `generic_app` repeatedly with `generic_app_name/_url/_folder/_icon/_exec/_autostart/_categories` vars — it downloads a binary/AppImage and renders a `.desktop` entry. To add an app, add another `generic_app` block to the host playbook, not a new role — unless the app ships its own updater, as kDrive does through `roles/kdrive`.

**Renovate updates those URLs in place.** `renovate.json` has custom regex managers matching a `# renovate: datasource=... depName=...` comment immediately above a `generic_app_url:` line. New pinned download URLs should carry that comment so they stay updated; if a URL shape is unusual, the regexes in `renovate.json` may need extending (see commit `90258ff`).

**`roles/commons` owns the shell environment.** It symlinks (or copies, per `commons_symlink_as_link`) everything in `commons_symlinks` from `roles/commons/files/` into `$HOME`, injects `~/.bashrc.d` sourcing and a rendered `commons_custom_scripts` block into `~/.bashrc` via `blockinfile` markers, and manages PATH additions. Shell helpers live in `roles/commons/files/.bashrc.d/*.sh`. `commons_custom_scripts` entries are `{command, script}` pairs; the script is only emitted when `command` exists on the machine.

**`roles/mise` bootstraps mise from COPR** and templates `~/.config/mise/config.toml` from `mise_global_plugins` (defaults in the role, overridden in `host_vars`), with a handler running `mise install`.

Vendored Galaxy content (`galaxy_roles/`, `collections/`) is gitignored and installed from `requirements.yml`; `ansible.cfg` sets `roles_path`/`collections_path` to those directories. Facts are cached in `./facts` (gitignored), and every run appends to `./run.log` (gitignored, ~1.4 MB — do not read it wholesale).

## Secrets

Three files are Ansible Vault encrypted: `host_vars/gop/vault.yml`, `roles/gop/templates/ssh_hosts.j2`, `roles/gop/templates/aws_config.j2`. The password is extracted from a KeePassXC database by `./scripts/extract-secrets.sh <db.kdbx>` into `~/.ansible_vault.txt`; vault commands and the GOP playbook expect `ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.txt`. Never commit a decrypted version of these files.

## Conventions

- Ansible-lint runs with default rules, so **role variables must be prefixed with the role name** (`commons_*`, `generic_app_*`, `mise_*`) and tasks need `name:` and explicit `mode:`.
- FQCNs everywhere (`ansible.builtin.*`, `community.general.*`).
- Task/defaults files use both `.yml` and `.yaml` inconsistently — match whatever the role you are editing already uses.
- Prefer `ansible_facts['env']['HOME']` over `~` in new tasks (newer roles do this; older ones use `~`).
- yamllint config allows 140-char lines and forbids octal values — quote file modes (`"0755"`).
- Each role carries a boilerplate `meta/main.yml` + `README.md` generated by `scripts/batch_update.sh` from `scripts/templates/`.
