#!/bin/env bash

function __exec_nohupped__(){
    (:; nohup "${@}" &>/dev/null &)
}
function open(){
    for file in "${@}"; do __exec_nohupped__ "xdg-open" "${file}"; done
}
function run(){
    __exec_nohupped__ "${@}" 
}

unset -f command_not_found_handle

