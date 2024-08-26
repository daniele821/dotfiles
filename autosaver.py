#!/bin/python3

import os

SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": SCRIPT_DIR + "/backup",
        "config": SCRIPT_DIR + "/config",
        "init": SCRIPT_DIR + "/init",
        "bigfiles": SCRIPT_DIR + "bigfiles"}
FILES = {"track": DIRS["config"] + "/files_to_track.txt"}
