#!/bin/env bash

### startup program ###
eval "$(zoxide init --hook none --no-cmd bash)"

## startup programs configs ##
function __zoxide_euristically__() {
    \cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
function __zoxide_add_paths__() {
    if [[ "$#" -eq 0 ]]; then
        zoxide add "${PWD}"
        return 0
    fi
    for path in "${@}"; do
        path="$(realpath "${path}")"
        if [[ -d "${path}" ]]; then
            zoxide add "${path}"
        fi
    done
    return 0
}
alias cd='__zoxide_euristically__'
alias za='__zoxide_add_paths__'
alias ze='zoxide edit'
alias zi='__zoxide_zi'
alias zl='zoxide query -ls'
