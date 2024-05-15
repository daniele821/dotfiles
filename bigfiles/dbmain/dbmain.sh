#!/bin/env bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
export DB_MAIN_BIN="${SCRIPT_DIR}/bin"
export PATH=$DB_MAIN_BIN:$PATH
export LD_LIBRARY_PATH=$DB_MAIN_BIN:$DB_MAIN_BIN/../java/jre/lib/amd64/server:$LD_LIBRARY_PATH
db_main "${@}"
