#!/bin/python3

import os
from enum import Enum
from pathlib import Path

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
