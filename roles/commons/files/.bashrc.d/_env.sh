#!/usr/bin/env bash

# French layout
# setxkbmap fr

# User specific environment and startup programs
TERM=xterm-256color
export TERM

# Change default ls colors
# @see https://askubuntu.com/a/466203
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS

GPG_TTY=$(tty)
export GPG_TTY

# For readability
ANSIBLE_NOCOWS=1
export ANSIBLE_NOCOWS

EDITOR=$(which vim)
export EDITOR=$EDITOR

SOPS_AGE_KEY_FILE=~/.age.key
export SOPS_AGE_KEY_FILE=$SOPS_AGE_KEY_FILE

# Keep tool caches on disk, not in /tmp (tmpfs, ends up in zram)
TRIVY_CACHE_DIR=~/.cache/trivy
export TRIVY_CACHE_DIR
TF_PLUGIN_CACHE_DIR=~/.cache/tofu/plugins
export TF_PLUGIN_CACHE_DIR
# tofu does not create the plugin cache directory itself
[ -d "$TF_PLUGIN_CACHE_DIR" ] || mkdir -p "$TF_PLUGIN_CACHE_DIR"
