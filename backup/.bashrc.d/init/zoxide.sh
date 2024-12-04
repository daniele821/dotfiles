#!/bin/bash

eval "$(zoxide init --no-cmd bash)"

alias z='__zoxide_euristically__'
alias zi='__zoxide_zi'

function __zoxide_euristically__() {
    \cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
