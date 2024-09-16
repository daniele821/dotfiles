#!/bin/python3

import os
from shutil import copyfile
from filecmp import cmp


def are_files_different(file1, file2):
    return not cmp(file1, file2)


def copy_file(src, dst):
    create_dir(os.path.dirname(dst))
    copyfile(src, dst)


def read_file(file):
    with open(file, "r") as buffer:
        return buffer.read()


def create_file(file):
    with open(file, "w"):
        pass


def delete_file(file, del_empty_dir=False):
    os.remove(file)
    if del_empty_dir:
        dir = file
        while True:
            dir = os.path.dirname(dir)
            try:
                os.rmdir(dir)
            except Exception:
                break


def create_dir(dir):
    os.makedirs(dir, exist_ok=True)


def all_files(dir, relpath=None):
    files = []
    for root, _, dirfiles in os.walk(dir):
        for fname in dirfiles:
            fname = os.path.join(root, fname)
            if relpath is not None:
                fname = os.path.relpath(fname, relpath)
            files.append(fname)
    return files
