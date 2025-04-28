#!/bin/env bash

set -e

# utility functions
function ask_user() {
    echo -en "\x1b[1;37m${*}? \x1b[m"
    read -r answer </dev/tty
    if [[ "${answer,,}" == 'y' ]]; then
        return 0
    elif [[ "${answer,,}" == 'n' || "$answer" == '' ]]; then
        return 1
    else
        echo 'invalid answer, retry:'
        ask_user "$@"
        return
    fi
}

{
    if ask_user "Do you really want to reboot"; then
        reboot
    fi
} </dev/tty
