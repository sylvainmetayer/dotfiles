# kdrive

Installs [oRiamn/kdrive-auto-update](https://github.com/oRiamn/kdrive-auto-update), which downloads the
latest kDrive AppImage published on <https://www.infomaniak.com/drive/latest> and keeps it up to date at
each login, instead of pinning a download URL by hand.

The role reproduces what the upstream (interactive) `launcher.sh` does — install the script in
`~/.local/bin`, record the architecture in `~/.config/kdrive-auto-update/architecture` and register the
updater in `~/.config/autostart` — and adds:

- a `kdrive-launch` wrapper resolving the most recent AppImage, so the desktop entry survives updates;
- a `kDrive.desktop` application entry with the dotfiles icon and the Qt environment variables.

`kdrive_auto_update_ref` pins the upstream commit and is tracked by Renovate.

Set `kdrive_remove_legacy_install: true` once to clean up the AppImage previously installed through the
`generic_app` role (paths listed in `kdrive_legacy_paths`).

See `defaults` folder for available variables and playbook linked in collection for usage.
