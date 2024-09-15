#!/bin/python3

from subprocess import run


def diff(old, new):
    run(["diff", "--color", "-u", old, new])


def edit(file):
    run(["nvim", file])


def run_and_get_status(file):
    return run([file]).returncode == 0


def git_pull(gitdir):
    run(["git", "-C", gitdir, "pull"])


def git_push(gitdir):
    run(["git", "-C", gitdir, "push"])


def git_status(gitdir):
    run(["git", "-C", dir, "status", "-su"])


def git_diff(gitdir, reverse=False):
    cmd = ["git", "-C", gitdir, "diff", "HEAD", "--diff-filter=adcr"]
    run(cmd + ["-R"] if reverse else cmd)


def git_restore_all(gitdir):
    run(["git", "-C", gitdir, "reset", "HEAD"])
    run(["git", "-C", gitdir, "restore", "--staged", gitdir])
    run(["git", "-C", gitdir, "restore", gitdir])
    run(["git", "-C", gitdir, "clean", "-fdq"])


def git_commit_all(gitdir, commit_msg):
    run(["git", "-C", gitdir, "add", gitdir])
    run(["git", "-C", gitdir, "commit", "-m", commit_msg])


def has_git_changed(gitidir):
    cmd = ['git', '-C', dir, 'status', '-s']
    return run(cmd, capture_output=True, text=True).stdout.strip()
