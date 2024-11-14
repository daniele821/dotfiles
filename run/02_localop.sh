#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    # mandatory init operations
    if ! [[ -d "/personal" ]]; then # create personal dirs
        sudo mkdir -p /personal/{data,repos} || exit 1
        sudo chown "${USER}":"${USER}" /personal/{data,repos}
        echo "created personal directory in /personal"
    fi

    # restore backup files
    if ask_user 'Do you want to restore all backup files'; then
        SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
        SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
        "${SCRIPT_DIR}/../autosaver" restoreall
    fi

    # create ssh keys for github
    if ask_user 'Do you really want to create new ssh keys'; then
        for user in daniele821 danix1234; do
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}"
        done
    fi

    # gsettings configurations (done here instead of installing gnome-tweaks)
    if ask_user 'Do you really want to tweaks few gsettings preferences'; then
        # tweaks
        gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
        gsettings set org.gnome.mutter center-new-windows true
        gsettings set org.gnome.mutter attach-modal-dialogs false

        # use 'dconf watch /' to see how gnome settings app set preferences

        # Displays
        gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3200
        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0.0
        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 0.0
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

        # Power
        gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
        gsettings set org.gnome.settings-daemon.plugins.power power-button-action nothing
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
        gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100
        gsettings set org.gnome.desktop.session idle-delay 0

        # Multitasking
        gsettings set org.gnome.desktop.interface enable-hot-corners false
        gsettings set org.gnome.mutter dynamic-workspaces false
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

        # Appereance
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        gsettings set org.gnome.desktop.interface accent-color teal

        # Keyboard
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'it')]"
        gsettings set org.gnome.desktop.input-sources per-window true
        gsettings set org.gnome.settings-daemon.plugins.media-keys screenreader '[]'
        gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>f']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>i']"
        gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
        gsettings set org.gnome.shell.keybindings toggle-message-tray '[]' && gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch Terminal'
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ptyxis --new-window'
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'

        # Privacy & Security
        gsettings set org.gnome.desktop.privacy recent-files-max-age -1
        gsettings set org.gnome.desktop.privacy remove-old-trash-files true
        gsettings set org.gnome.desktop.privacy remove-old-temp-files true

        # System
        gsettings set org.gnome.desktop.interface clock-format 24h
        gsettings set org.gtk.Settings.FileChooser clock-format 24h
    fi

} </dev/tty

exit 0
