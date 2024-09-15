#!/bin/python3

import os
import shutil


def copy_file(src, dst):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copyfile(src, dst)


def read_file(file):
    with open(file, "r") as buffer:
        return buffer.read()


def create_file(file):
    with open(file, "w"):
        pass


def all_files(dir, relpath=None):
    files = []
    for root, _, dirfiles in os.walk(dir):
        for fname in dirfiles:
            fname = os.path.join(root, fname)
            if relpath is not None:
                fname = os.path.relpath(fname, relpath)
            files.append(fname)
    return files
