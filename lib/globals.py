#!/bin/python3

import os

HOME = os.path.expanduser("~")
SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": os.path.join(SCRIPT_DIR, "backup"),
        "config": os.path.join(SCRIPT_DIR, "config"),
        "init": os.path.join(SCRIPT_DIR, "init"),
        "bigfiles": os.path.join(SCRIPT_DIR, "bigfiles")}
FILES = {"track": os.path.join(DIRS["config"], "files_to_track.txt")}


FLAGS = "dfntvy"
ACTIONS = {
    " ": "dntvy",
    "b": "dfntvy",
    "c": "dnty",
    "e": "ny",
    "h": "",
    "i": "",
    "r": "ny",
    "s": "dntvy",
    "u": "fnty",
}


def opts_to_auto_answer(opts):
    if "n" in opts:
        return "n"
    if "y" in opts:
        return "y"
