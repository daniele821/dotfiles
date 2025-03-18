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

    # download fira code nerd font
    if ask_user 'Do you really want to download firacode nerd font'; then
        FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
        [[ -f "${FIRACODE_DIR}" ]] && rm -rf "$HOME/.local/share/fonts/FiraCode" # rewritten manually: rm -rf is HUGELY dangerous!
        mkdir -p "${FIRACODE_DIR}"
        cd "$(mktemp -d /tmp/firacode-fontXXXXXXXXXXXXXXXXXXX)" || exit 1
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O Firacode.zip
        unzip ./Firacode.zip
        mv ./*.ttf "${FIRACODE_DIR}/"

        # check installation worked
        rmdir "${FIRACODE_DIR}" &>/dev/null && report_fail 'installation of nerd fonts failed!'
    fi

    # download zig binary
    if ask_user 'Do you really want to download zig'; then
        TMPFILE="$(mktemp)"
        VERSION="$(curl https://ziglang.org/download/index.json | jq -r 'keys_unsorted | map(select(. != "master")) | .[0]')"
        echo -e "\e[1;33mINFO: downloading latest stable version: $VERSION\e[m" >/dev/tty
        TARBALL="$(curl https://ziglang.org/download/index.json | jq -r --arg version "$VERSION" --arg arch "$(uname -m)" '.[$version].[$arch + "-linux"].tarball')"
        wget "$TARBALL" -O "$TMPFILE"
        [[ -d /usr/local/lib/zig ]] && sudo rm -rf /usr/local/lib/zig
        sudo mkdir /usr/local/lib/zig
        sudo tar xf "$TMPFILE" -C /usr/local/lib/zig --strip-components=1
        sudo chown root:root -R /usr/local/lib/zig
        [[ -e /usr/local/bin/zig ]] && sudo rm /usr/local/bin/zig
        sudo ln -s /usr/local/lib/zig/zig /usr/local/bin/zig
        rm "$TMPFILE"

        [[ -f /usr/local/bin/zig && -d /usr/local/lib/zig ]] || report_fail 'installation of zig failed!'
    fi

    # download kitten
    if ask_user 'Do you really want to install kitten'; then
        case "$(uname -m)" in
        x86_64)
            TMP_FILE="$(mktemp)"
            wget https://github.com/kovidgoyal/kitty/releases/latest/download/kitten-linux-386 -O "${TMP_FILE}"
            chmod +x "${TMP_FILE}"
            sudo mv "${TMP_FILE}" /usr/local/bin/kitten
            ;;
        *) report_fail "not supported platform: $(uname -m)" ;;
        esac

        [[ -f /usr/local/bin/kitten ]] || report_fail 'installation of kitten failed!'
    fi

} </dev/tty

exit 0
