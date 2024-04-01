#!/bin/env bash

function __exec_nohupped__(){
    (:; nohup "${@}" &>/dev/null &)
}
function __hypr_workspace__(){
    hyprctl dispatch workspace "${@}" &>/dev/null
}
function open(){
    for file in "${@}"; do __exec_nohupped__ "xdg-open" "${file}"; done
}
function run(){
    __exec_nohupped__ "${@}" 
}
function openhypr(){
    __hypr_workspace__ "${1}" && open "${@:2}"
}
function runhypr(){
    __hypr_workspace__ "${1}" && run "${@:2}"
}
