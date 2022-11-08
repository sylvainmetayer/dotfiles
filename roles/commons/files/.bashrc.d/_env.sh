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

SOPS_AGE_KEY_FILE=~/age.key
export SOPS_AGE_KEY_FILE=$SOPS_AGE_KEY_FILE
