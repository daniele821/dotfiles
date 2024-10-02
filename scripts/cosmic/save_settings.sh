#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
COSMIC_DIR="${HOME}/.config/cosmic"
COSMIC_ZIP="cosmic.tar.gz"

! [[ -d "${COSMIC_DIR}" ]] && echo 'there is no cosmic settings to backup' && exit 1

cd "$(mktemp -d)" || exit 1
cp -r "${COSMIC_DIR}" ./
tar czf "${COSMIC_ZIP}" ./*
mv "${COSMIC_ZIP}" "${SCRIPT_DIR}"
