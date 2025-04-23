#!/bin/env bash

set -e

# utility functions
function ask_user() {
    echo -en "\x1b[1;37m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    if ask_user "Do you really want to reboot"; then
        reboot
    fi
} </dev/tty
