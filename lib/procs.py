#!/bin/python3

from subprocess import run


def diff(old, new):
    return run(["diff", "--color", "-u", old, new])


def edit(file):
    return run(["nvim", file])


def execute(file):
    return run(["nvim", file])


def git_pull(gitdir):
    run(["git", "-C", gitdir, "pull"])


def git_push(gitdir):
    run(["git", "-C", gitdir, "push"])


def git_restore(gitdir):
    run(["git", "-C", gitdir, "reset", "HEAD"])
    run(["git", "-C", gitdir, "restore", "--staged", gitdir])
    run(["git", "-C", gitdir, "restore", gitdir])
    run(["git", "-C", gitdir, "clean", "-fdq"])


def git_commit(gitdir):
    pass
