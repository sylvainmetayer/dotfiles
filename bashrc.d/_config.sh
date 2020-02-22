#!/usr/bin/env bash

export TERM=xterm-256color

# Change default ls colors
# @see https://askubuntu.com/a/466203
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS

# https://superuser.com/questions/288714/bash-autocomplete-like-zsh/835047#835047
# bind 'set show-all-if-ambiguous on'
# bind 'TAB:menu-complete'

# Mutiple terminal session can write to history
# shopt -s histappend
