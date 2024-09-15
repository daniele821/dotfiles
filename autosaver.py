#!/bin/python3

import os
from enum import Enum
from pathlib import Path
from lib.file import read_file, all_files, create_file, create_dir

HOME = Path.home()
SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": os.path.join(SCRIPT_DIR, "backup"),
        "config": os.path.join(SCRIPT_DIR, "config"),
        "init": os.path.join(SCRIPT_DIR, "init"),
        "bigfiles": os.path.join(SCRIPT_DIR, "bigfiles")}
FILES = {"track": os.path.join(DIRS["config"], "files_to_track.txt"),
         "notdiff": os.path.join(DIRS["config"], "files_to_notdiff.txt")}


ACTIONS = Enum("ACTIONS", [
    "LIST", "UNTRACKED", "SAVE", "RESTORE", "COMMIT", "EDIT", "INIT", "RUN"
])
FLAGS = Enum("FLAGS", [
    "DIFFS", "FORCE", "NO", "YES", "TOGGLE", "VERBOSE"
])


def load_config(conf):
    files = []
    if os.path.isfile(conf):
        for line in read_file(conf).splitlines():
            if not line.startswith("/") and line:
                orig_file = os.path.join(HOME, line)
                back_file = os.path.join(DIRS["backup"], line)
                for file in (orig_file, back_file):
                    if os.path.isfile(file):
                        files.append(file)
                    elif os.path.isdir(file):
                        files.extend(all_files(file))
    return files


def init_files():
    for dir in DIRS.values():
        if not os.path.exists(dir):
            create_dir(dir)
    for file in FILES.values():
        if not os.path.exists(file):
            create_file(file)
