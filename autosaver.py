#!/bin/python3

import os
import getopt
import sys

SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": SCRIPT_DIR + "/backup",
        "config": SCRIPT_DIR + "/config",
        "init": SCRIPT_DIR + "/init",
        "bigfiles": SCRIPT_DIR + "bigfiles"}
FILES = {"track": DIRS["config"] + "/files_to_track.txt"}


def parse_options() -> list[str]:
    """
    parse parameters passed from command line
    N.B: only parses short options, without associated values
    """
    args = sys.argv[1:]
    if len(args) == 1:
        match args[0]:
            case "save": return ['s', 'c', 'v', 'y']
            case "restore": return ['b', 'v', 'y']
            case "init": return ['r', 'y']
            case "edit": return ['e', 'y']
            case "help": return ['h']
    args = [s for s in args if s.startswith("-")]
    opts = [c[1:] for c, _ in getopt.getopt(args, 'abcd')[0]]
    return opts
