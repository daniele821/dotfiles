#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
GOLANG_DIR="${SCRIPT_DIR}/devel"
GOLANG_EXE="${SCRIPT_DIR}/autosaver"
GOLANG_MAIN="${GOLANG_DIR}/cmd/autosaver/main.go"

! cd "${GOLANG_DIR}" && echo 'golang devel directory is missing!' && exit 1
go build -o "${GOLANG_EXE}" "${GOLANG_MAIN}"
