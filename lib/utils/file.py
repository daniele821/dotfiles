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
