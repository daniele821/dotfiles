#!/bin/python3

from subprocess import run


def diff(old, new):
    return run(["diff", "--color", "-u", old, new])


def edit(file):
    return run(["nvim", file])


def execute(file):
    return run(["nvim", file])
