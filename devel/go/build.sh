#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

TMPDIR="$(mktemp -d)"

cd "${SCRIPT_DIR}" || exit 1

changes="$(git -C "${SCRIPT_DIR}/../.." status -su | wc -l)"
if [[ "${changes}" == "0" ]]; then
    echo 'no changes were made'
    exit 0
fi

if [[ "$1" == "-y" ]]; then
    lines="$(grep -c "fmt.Println.*" "${SCRIPT_DIR}/cmd/autosaver/main.go")"
    [[ "$lines" != "1" ]] && "main file MUST have a single fmt.Println call!"
    sed -i "s/fmt.Println.*/fmt.Println(\"compiled at $(date)\")/" "${SCRIPT_DIR}/cmd/autosaver/main.go"
fi

go build -o "${TMPDIR}/" "${SCRIPT_DIR}/cmd/autosaver/main.go"
mv "${TMPDIR}/"* "${SCRIPT_DIR}/autosaver"

cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"

if [[ "$1" == "-y" ]]; then
    "${SCRIPT_DIR}/../../autosaver" commit
fi
