#!/bin/env bash

### various fixes ###
unset -f command_not_found_handle

### startup program ###
eval "$(zoxide init bash)"
eval "$(starship init bash)"

# config
export STARSHIP_LOG=error
function clear_zoxide_interactive(){
    zoxide query -ls | fzf -m | while read -r score path; do
        zoxide remove "${path}";
		echo -e "\e[1;33m${path} \e[1;31m(${score})\e[m"
    done;
}
function zoxide_euristically(){
	\cd "$@" &>/dev/null || z "$@" &>/dev/null
}
function zoxide_interactive() {
	\cd "$@" &>/dev/null && return 0
    CHOISES="$(zoxide query -l "$@" | wc -l)" 
    [[ "${CHOISES}" -le "1" ]] && z "$@"
    [[ "${CHOISES}" -gt "1" ]] && zi "$@"
}
alias cd='zoxide_euristically'
alias ci='zoxide_interactive'
alias zd='clear_zoxide_interactive'
