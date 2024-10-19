#!/bin/bash

export STARSHIP_LOG=error
export starship_precmd_user_func="blastoff"

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(direnv hook bash)"

function blastoff() {
    git status -s &>/dev/null
}
function __zoxide_euristically__() {
    cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
function __exec_nohupped__() {
    (: && nohup "$@" &>/dev/null &)
}
function run() {
    __exec_nohupped__ "$@"
}
function open() {
    for file in "${@}"; do __exec_nohupped__ xdg-open "$file"; done
}

export HISTCONTROL="ignoredups"
export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias tree='lsd --group-dirs first --tree'
alias cat='batcat'
alias cd='__zoxide_euristically__'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

for i in - {0..9}; do
    bind -r "\e$i"
done
bind -x '"\C-l": clear'

if [[ "${TERM}" =~ "kitty" ]]; then
    function preview() {
        kitten icat --align=left --place "$(tput cols)"x"$(tput lines)"@0x0 "${@}" | less -r
    }
fi
