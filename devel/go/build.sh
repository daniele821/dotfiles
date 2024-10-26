#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

TMPDIR="$(mktemp -d)"

go build -o "${TMPDIR}/" "${SCRIPT_DIR}/cmd/autosaver/main.go"
mv "${TMPDIR}/"* "${SCRIPT_DIR}/autosaver"
