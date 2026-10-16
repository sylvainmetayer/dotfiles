# data_disk

Encrypts a secondary disk with LUKS2, opens it at boot with a key file kept on the (already encrypted) system
disk, formats it in btrfs, mounts the top level and creates btrfs subvolumes, optionally linked from elsewhere
(e.g. a sync folder in `$HOME`). A symlink rather than a mount: if the disk is missing at boot the link dangles,
so a sync client finds no folder (and stops) instead of an empty one (and deletes everything remotely).

The role is a no-op until `data_disk_device` is set, so it can sit in any playbook: only the host_vars of a
machine with a disk to manage enable it. Formatting needs `-e data_disk_format=true` **and** a blank disk (no
signature at all, as left by `blkdiscard` or `wipefs -a`); a disk holding anything but LUKS stops the run.

After the first run, add a recovery passphrase (keep it in KeePassXC):

```bash
sudo cryptsetup luksAddKey --key-file /etc/cryptsetup-keys.d/data.key /dev/disk/by-id/<disk>
```

When the disk is not mounted, `data_disk_mountpoint` is an empty root-owned folder: an application running as
the user cannot recreate the subvolume path there, so it finds its folder missing. Keep it that way.

Moving an existing sync folder behind a link is manual. For kDrive, which tracks local files by inode (a copy
gets new ones) and stores the canonical path (`/data/@kdrive`) of the folder it is given:

1. in kDrive, remove the sync pair while keeping the local files, then quit kDrive;
2. copy with dates preserved (`rsync -aHAX old/ /data/@kdrive/`) and check the copy;
3. rename the old folder, add `link:` to the subvolume and run only this role (`--tags data_disk`: a full run
   replays the kdrive role, which restores its autostart);
4. create a new sync pair on the link and delete the old folder only after a clean sync.

If the disk is missing, the role fails the host and the next roles of the playbook do not run: unplugged on
purpose, run with `--skip-tags data_disk`.

See `defaults` folder for available variables and playbook linked in collection for usage.
