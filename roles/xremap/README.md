# xremap

Installs [xremap](https://github.com/xremap/xremap) as a user service, to remap keys per application
and per device — the GOP use case being a presenter remote whose `KEY_PAGEDOWN` must send `KEY_ENTER`
inside gnome-terminal (see issue #56).

The role installs the release matching `xremap_flavour` (`gnome` by default) under
`~/.local/share/xremap/<version>`, links it as `~/.local/bin/xremap`, renders
`~/.config/xremap/config.yml` from `xremap_modmap` / `xremap_keymap` and runs it through a
`xremap.service` user unit started with `--watch=config`, so a config change is picked up without a
restart.

Two privileged bits are needed for xremap to run without root:

- a udev rule tagging `uinput` with `uaccess`, written to `xremap_udev_rule_file`;
- the user added to the `input` group, which only takes effect at the **next login**.

Under Wayland xremap cannot see the focused window by itself, so the
[gnome extension](https://extensions.gnome.org/extension/5060/xremap/) is installed as well through
`jaredhocutt.gnome_extensions`. Set `xremap_install_gnome_extension: false` on X11 or another desktop.

`xremap_version` is pinned and tracked by Renovate.

See `defaults` folder for available variables and playbook linked in collection for usage.
