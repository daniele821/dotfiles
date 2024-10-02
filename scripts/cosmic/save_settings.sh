#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

# checks
! [[ -d "${HOME}/.config/cosmic" ]] && echo 'there is no cosmic settings to backup' && exit 1

# create temporary directory
TMP_DIR="/tmp/cosmic-backup-script"
mkdir -p "${TMP_DIR}"
TMP_DIR="$(mktemp -d "${TMP_DIR}/XXXXXXXXXXXXXXXXXXXXXXXXXXXX")"

# backup settings
cp -r "${HOME}/.config/cosmic" "${TMP_DIR}/cosmic"
[[ -d "${SCRIPT_DIR}/.cosmic" ]] && mv "${SCRIPT_DIR}/.cosmic" "${TMP_DIR}/.cosmic"
mv "${TMP_DIR}/cosmic" "${SCRIPT_DIR}/.cosmic"

# cleanup
rm -rf /tmp/cosmic-backup-script/
