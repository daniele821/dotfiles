#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

# checks
! [[ -d "${SCRIPT_DIR}/.cosmic" ]] && echo 'there is no backup file, to restore settings from' && exit 1
[[ "$(tty)" != "/dev/tty"* ]] && [[ -z "${XDG_CURRENT_DESKTOP}" ]] && echo 'you need to be in a tty, to safely run this script' && exit 1

# create temporary directory
TMP_DIR="/tmp/cosmic-backup-script"
mkdir -p "${TMP_DIR}"
TMP_DIR="$(mktemp -d "${TMP_DIR}/XXXXXXXXXXXXXXXXXXXXXXXXXXXX")"

# restore settings
[[ -d "${HOME}/.config/cosmic" ]] && mv "${HOME}/.config/cosmic" "${TMP_DIR}/"
cp -r "${SCRIPT_DIR}/.cosmic" "${HOME}/.config/cosmic"

# cleanup
rm -rf /tmp/cosmic-backup-script/
