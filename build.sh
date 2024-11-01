#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

LANGUAGE="$1"
BUILD_DIR="${SCRIPT_DIR}/devel/${LANGUAGE}"

[[ -z "${LANGUAGE}" ]] && echo "you need to write the language to use" && exit 1
! [[ -d "${BUILD_DIR}" ]] && echo "$LANGUAGE is not a valid language" && exit 1

if [[ "${LANGUAGE}" == "go" ]]; then
    cd "${BUILD_DIR}" || exit 1
    go build -o "${BUILD_DIR}/autosaver" "${BUILD_DIR}/cmd/autosaver/main.go"
fi

cp "${BUILD_DIR}/autosaver" "${SCRIPT_DIR}/autosaver"
cp "${BUILD_DIR}/HELP.md" "${SCRIPT_DIR}/HELP.md"
