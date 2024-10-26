#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

TMPDIR="$(mktemp -d)"

cd "${SCRIPT_DIR}" || exit 1

go build -o "${TMPDIR}/" "${SCRIPT_DIR}/cmd/autosaver/main.go"
mv "${TMPDIR}/"* "${SCRIPT_DIR}/autosaver"

[[ "$1" == "-y" ]] && cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"

:
