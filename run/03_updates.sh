#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1;37m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}
function report_fail() {
    echo -e "\x1b[1;31m${*}\x1b[m"
    echo -n "type enter to continue... "
    read -r _ </dev/tty
}

{
    # download starship
    if ask_user 'Do you really want to download starship locally'; then
        curl -sS https://starship.rs/install.sh | sh

        # check installatin worked
        [[ -f /usr/local/bin/starship ]] || report_fail 'installation of starship failed!'
    fi

} </dev/tty

exit 0
