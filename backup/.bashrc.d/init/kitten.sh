#!/bin/bash

function preview() {
    kitten icat "$@" | less -r
}
