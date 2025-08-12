#!/bin/env bash

set -e

# global variables often reused
DOTFILES_ROOT="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/../)"

# restore firefox backup
echo -e "\e[1;37minitializing firefox...\e[m"
killall firefox 2>/dev/null || true
rm -rf ~/.mozilla
cp -r "$DOTFILES_ROOT/others-script/mozilla" ~/.mozilla
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"
curl -L "https://addons.mozilla.org/firefox/downloads/latest/darkreader/addon-953454-latest.xpi" -o addon@darkreader.org.xpi
curl -L "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/addon-406847-latest.xpi" -o sponsorBlocker@ajay.app.xpi
curl -L "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi" -o uBlock0@raymondhill.net.xpi
for profile in "hkjdcvhm.default" "kvgujw0x.default-release"; do
    profile_path="$HOME/.mozilla/firefox/$profile"
    mkdir -p "$profile_path/extensions/"
    cp "$TMP_DIR/"* "$profile_path/extensions"
done
rm -rf "$TMP_DIR"

# install Firacode font
echo -e "\e[1;37minstalling firacode nerd font...\e[m"
FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
rm -rf "$FIRACODE_DIR"
mkdir -p "$FIRACODE_DIR"
cd "$FIRACODE_DIR"
curl -L -o Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip Firacode.zip >/dev/null
rm Firacode.zip LICENSE README.md

# restore files
echo -e "\e[1;37mrestoring dotfiles...\e[m"
BRANCH="" "$DOTFILES_ROOT/autosaver" restoreall

# download git repos
echo -e "\e[1;37mrestoring git repos...\e[m"
BRANCH="" NO_PROMPT="" "$DOTFILES_ROOT/autosaver" git
