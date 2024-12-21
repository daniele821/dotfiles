#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1;37m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    # add danish LC_TIME to set time format to 24h
    if ! grep -x 'LC_TIME="en_DK.UTF8"' /etc/locale.conf &>/dev/null; then
        echo -e "\e[1;37m/etc/locale.conf:\e[m"
        \cat /etc/locale.conf
        if ask_user "Do you really want to set 24h time format (LC_TIME=en_DK.UTF-8)"; then
            if grep 'LC_TIME=' /etc/locale.conf &>/dev/null; then
                sudo sed -i 's/LC_TIME=.*/LC_TIME="en_DK-UTF8"/' /etc/locale.conf &>/dev/null
            else
                echo 'LC_TIME="en_DK.UTF8"' | sudo tee -a /etc/locale.conf &>/dev/null
            fi
            \cat /etc/locale.conf
        fi
    fi
} </dev/tty

exit 0
