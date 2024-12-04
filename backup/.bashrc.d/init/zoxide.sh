#!/bin/bash

eval "$(zoxide init bash)"

alias cd='__zoxide_euristically__'

function __zoxide_euristically__() {
    \cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
alias ci='__zoxide_zi'
alias ce='zoxide edit'
