#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

eval "$(direnv hook bash)"

function __exec_nohupped__() {
    (: && nohup "$@" &>/dev/null &)
}
function run() {
    __exec_nohupped__ "$@"
}
function open() {
    for file in "${@}"; do __exec_nohupped__ xdg-open "$file"; done
}
function preview() {
    kitten icat --align=left --background=#232627 --place "$(tput cols)"x"$(tput lines)"@0x0 "${@}" | less -r
}
function fpreview() {
    preview --scale-up "${@}"
}

complete -f preview
complete -f fpreview
complete -f open
complete -c run

alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias tree='lsd --group-dirs first --tree'
alias cat='bat'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

unset command_not_found_handle
for i in - {0..9}; do bind -r "\e$i"; done
bind -x '"\C-l": clear'
