#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
CONF_DIR="${HOME}/.config"
COSMIC_NAME="cosmic"
COSMIC_DIR="${CONF_DIR}/${COSMIC_NAME}"
COSMIC_ZIP="cosmic.tar.gz"
COSMIC_PATH="${SCRIPT_DIR}/${COSMIC_ZIP}"
TTY="$(tty)"

! [[ -f "${COSMIC_PATH}" ]] && echo 'there is no backup file, to restore settings from' && exit 1
[[ "${TTY:0:8}" != "/dev/tty" ]] && echo 'you need to be in a tty, to safely run this script' && exit 1

cd "$(mktemp -d)" || exit 1
cp "${COSMIC_PATH}" "${COSMIC_ZIP}"
tar xzf "${COSMIC_ZIP}"
[[ -d "${COSMIC_DIR}" ]] && mv "${COSMIC_DIR}" ".${COSMIC_NAME}.bak"
mv "${COSMIC_NAME}" "${CONF_DIR}"
