#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

cd "${SCRIPT_DIR}" || exit 1

go build -o "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/cmd/autosaver/main.go"
cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"
