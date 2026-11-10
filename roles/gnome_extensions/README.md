# gnome_extensions

Installs and enables the Gnome Shell extensions listed in `gnome_extension_ids` (extensions.gnome.org ids),
for the user running the play. An extension already present in `~/.local/share/gnome-shell/extensions/` is left
untouched (never updated); one not published for the installed Gnome Shell version is skipped.

Ported from [jaredhocutt/ansible-gnome-extensions](https://github.com/jaredhocutt/ansible-gnome-extensions)
(archived upstream, MIT, see `LICENSE`), with `ansible_facts[...]` in place of the top-level facts that
ansible-core 2.24 removes.
