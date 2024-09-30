#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"
export HISTCONTROL="ignoredups"

eval "$(starship init bash)"
eval "$(zoxide init --no-cmd bash)"

alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias tree='lsd --group-dirs first --tree'
alias cat='bat'

function __zoxide_euristically__() {
    cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
alias cd='__zoxide_euristically__'
alias ce='zoxide edit'
alias ci='__zoxide_zi'
alias cl='zoxide query -ls'
