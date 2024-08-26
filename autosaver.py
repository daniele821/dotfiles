#!/bin/python3

import os
import getopt
import sys

SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": SCRIPT_DIR + "/backup",
        "config": SCRIPT_DIR + "/config",
        "init": SCRIPT_DIR + "/init",
        "bigfiles": SCRIPT_DIR + "/bigfiles"}
FILES = {"track": DIRS["config"] + "/files_to_track.txt"}


# UTILITY FUNCTIONS
def color(clr, str, output=True):
    clr_str = "\033["
    match clr:
        case "err": clr_str += "1;31m"
        case "file": clr_str += "1;34m"
        case "msg": clr_str += "1;33m"
    res = clr_str + str + "\033[m"
    if output:
        print(res, end="")
    else:
        return res


# ACTION FUNCTIONS
def init_files():
    for _, dir in DIRS.items():
        if not os.path.exists(dir):
            os.makedirs(dir)
    for _, file in FILES.items():
        if not os.path.exists(file):
            open(file, 'w').close()


# ACTUAL EXECUTION
def parse_options():
    args = sys.argv[1:]
    if len(args) == 1:
        match args[0]:
            case "save": return ['s', 'c', 'v', 'y']
            case "restore": return ['b', 'v', 'y']
            case "init": return ['r', 'y']
            case "edit": return ['e', 'y']
            case "help": return ['h']
    args = [s for s in args if s.startswith("-")]
    try:
        opts = [c[1:] for c, _ in getopt.getopt(args, 'bcdefhirsvy')[0]]
        return opts
    except getopt.GetoptError:
        color("err", "ERROR: an invalid option was passed!\n")
        exit(1)


def execute(opts):
    opts = set(opts)
    actions = set([opt for opt in opts if opt in 'behirs'])
    num_act = len(actions)
    if num_act >= 2:
        color("err", "ERROR: too many action flags were passed!\n")
        exit(1)
    action = None if num_act == 0 else actions.pop()
    match action:
        case "b" | "s" | None: pass
        case "e": pass
        case "h": pass
        case "i": init_files()
        case "r": pass
        case _: raise ValueError("UNREACHABLE CODE")


if __name__ == "__main__":
    execute(parse_options())
