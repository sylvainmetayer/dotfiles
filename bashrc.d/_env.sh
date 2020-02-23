#!/usr/bin/env bash

# French layout
setxkbmap fr

# User specific environment and startup programs
alias gpg=gpg2
export TERM=xterm-256color

# Change default ls colors
# @see https://askubuntu.com/a/466203
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS

export GPG_TTY=$(tty)

# For readability
export ANSIBLE_NOCOWS=1
