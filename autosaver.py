#!/bin/python3

import os
from enum import Enum
from pathlib import Path
from lib.file import read_file, all_files, create_file, create_dir
from lib.msg import error

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
    "LIST", "UNTRACKED", "SAVE", "BACKUP", "COMMIT", "EDIT", "INIT", "RUN"
])
FLAGS = Enum("FLAGS", [
    "DIFF", "FORCE", "NO", "YES", "TOGGLE", "VERBOSE"
])
ACTION_FLAGS = {
    "b": ACTIONS.BACKUP,
    "c": ACTIONS.COMMIT,
    "e": ACTIONS.EDIT,
    "i": ACTIONS.INIT,
    "r": ACTIONS.RUN,
    "s": ACTIONS.SAVE,
    "u": ACTIONS.UNTRACKED,
}
OPTION_FLAGS = {
    "d": FLAGS.DIFF,
    "f": FLAGS.FORCE,
    "n": FLAGS.NO,
    "t": FLAGS.TOGGLE,
    "v": FLAGS.VERBOSE,
    "y": FLAGS.YES,
}
ALL_FLAGS = ACTION_FLAGS | OPTION_FLAGS
DEFAULT_ACTION = ACTIONS.LIST
SHORTCUTS = {
    "save": ["-svy"],
    "restore": ["-bvy"],
    "commit": ["-cy"],
    "uncommit": ["-cty"],
    "untracked": ["-u"],
    "init": ["-ry"],
    "sc": ["-svy", "-cy"],
}


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


def parse_shortcuts(args):
    if len(args) == 1:
        pass


def parse_options(args):
    flag_opts = [arg for arg in args if arg.startswith("-")]
    input_flags = set()
    for flag_opt in flag_opts:
        input_flags.update(flag_opt[1:])
    flags = input_flags & ALL_FLAGS.keys()
    options = flags & OPTION_FLAGS.keys()
    action = flags & ACTION_FLAGS.keys()
    if input_flags - flags:
        error("some invalid flags were passed")
    if len(action) > 1:
        error("this script doesn't accept multiple action flags")
    action = ACTION_FLAGS[action.pop()] if len(action) == 1 else DEFAULT_ACTION
    options = [ALL_FLAGS[i] for i in options]
    return (action, options)
