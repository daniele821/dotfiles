#!/bin/bash

eval "$(starship init bash)"
eval "$(zoxide init --no-cmd bash)"

function blastoff() {
    git status -s &>/dev/null
}
function __zoxide_euristically__() {
    cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
function __exec_nohupped__() {
    (: ; nohup "$@" &>/dev/null &)
}
function run() {
    __exec_nohupped__ "$@"
}
function open() {
    for file in "${@}"; do __exec_nohupped__ xdg-open $file; done
}

export PATH="$HOME/.local/bin:$PATH"
export HISTCONTROL="ignoredups"
export starship_precmd_user_func="blastoff"
export STARSHIP_LOG=error
export EDITOR="nvim"

alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias tree='lsd --group-dirs first --tree'
alias cat='batcat'
alias cd='__zoxide_euristically__'
alias ce='zoxide edit'
alias ci='__zoxide_zi'
alias cl='zoxide query -ls'
