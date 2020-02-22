# .bash_profile
# This file is only reloaded on session openning (su with '-', GUI login, ssh, terminal tty with ctrl alt 1-6)

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
alias gpg=gpg2
export TERM=xterm-256color

# Change default ls colors
# @see https://askubuntu.com/a/466203
LS_COLORS=$LS_COLORS:'di=0;35:'
export LS_COLORS

export GPG_TTY=$(tty)

# https://superuser.com/questions/288714/bash-autocomplete-like-zsh/835047#835047
# bind 'set show-all-if-ambiguous on'
# bind 'TAB:menu-complete'

# Mutiple terminal session can write to history
# shopt -s histappend
