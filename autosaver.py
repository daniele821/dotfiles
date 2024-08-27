#!/bin/python3

import os
import getopt
import sys
import itertools as itt
import subprocess as proc
import filecmp as cmp
from shutil import copyfile as cp


SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": os.path.join(SCRIPT_DIR, "backup"),
        "config": os.path.join(SCRIPT_DIR, "config"),
        "init": os.path.join(SCRIPT_DIR, "init"),
        "bigfiles": os.path.join(SCRIPT_DIR, "bigfiles")}
FILES = {"track": os.path.join(DIRS["config"], "files_to_track.txt")}


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


def ask_user(msg, opts, clr=False):
    color("msg", msg) if clr else print(msg, end="")
    if 'y' in opts:
        print("y")
        return True
    return input().lower() == "y"


def get_inits():
    if os.path.exists(DIRS["init"]):
        return [entry.path for entry in os.scandir(DIRS["init"])]
    return []


def all_files(dir, relpath=None):
    files = []
    for root, _, dirfiles in os.walk(dir):
        for f in dirfiles:
            fname = os.path.join(root, f)
            if os.path.isfile(fname):
                if relpath is None:
                    files.append(fname)
                else:
                    files.append(os.path.relpath(fname, relpath))
    return files


def copy_file(src, dst):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    cp(src, dst)


# ACTION FUNCTIONS
def backup(opts):
    home = os.path.expanduser("~")
    backup = DIRS["backup"]
    track = FILES["track"]
    msg1 = " : backup file is missing"
    msg2 = "Do you really want to create the backup file? "
    msg3 = "[DANGER] Do you really want to delete the original file? "
    msg4 = " : original file is missing"
    msg5 = "Do you really want to delete the backup file? "
    msg6 = "Do you really want to create the original file? "
    msg7 = " : original and backup files differ"
    msg8 = "Do you really want to update the backup file? "
    msg9 = "Do you really want to update the original file? "
    msg10 = "Do you really want to commit all? "
    msg11 = "Do you really want to restore all? "

    # accumulate all tracked files
    files = set()
    files.update(all_files(backup, backup))
    if os.path.isfile(track):
        with open(track, "r") as buffer:
            for line in buffer.read().splitlines():
                if not line.startswith("/") and line.strip():
                    file = os.path.join(home, line)
                    if os.path.isfile(file):
                        files.add(line)
                    elif os.path.isdir(file):
                        files.update(all_files(file, home))
    files = sorted(files)

    # backup action
    for file in files:
        fhome = os.path.join(home, file)
        fback = os.path.join(backup, file)
        match os.path.isfile(fhome), os.path.isfile(fback):
            case True, False:
                color("file", fhome)
                print(msg1 if "v" in opts else "")
                if "s" in opts and ask_user(msg2, opts, True):
                    copy_file(fhome, fback)
                elif "b" in opts and "f" in opts:
                    if ask_user(msg3, opts, True):
                        os.remove(fhome)
            case False, True:
                color("file", fhome)
                print(msg4 if "v" in opts else "")
                if "s" in opts and ask_user(msg5, opts, True):
                    os.remove(fback)
                elif "b" in opts and ask_user(msg6, opts, True):
                    copy_file(fback, fhome)
            case True, True:
                if not cmp.cmp(fhome, fback):
                    color("file", fhome)
                    print(msg7 if "v" in opts else "")
                    if "d" in opts:
                        if "b" in opts:
                            proc.run(["diff", "--color", "-u", fhome, fback])
                        else:
                            proc.run(["diff", "--color", "-u", fback, fhome])
                    if "s" in opts and ask_user(msg8, opts, True):
                        copy_file(fhome, fback)
                    elif "b" in opts and ask_user(msg9, opts, True):
                        copy_file(fback, fhome)

    # commit
    if "c" in opts:
        dir = SCRIPT_DIR
        stdout = proc.run(['git', '-C', dir, 'status', '-s'],
                          capture_output=True, text=True).stdout
        if stdout.strip():
            if "s" in opts:
                proc.run(["git", "-C", dir, "pull"])
                proc.run(["git", "-C", dir, "status", "-su"])
                if "d" in opts:
                    proc.run(["git", "-C", dir, "--no-pager", "diff", "HEAD"])
                if ask_user(msg10, opts, True):
                    cmt = input(color("msg", "Write commit message: ", False))
                    if cmt:
                        proc.run(["git", "-C", dir, "add", dir])
                        proc.run(["git", "-C", dir, "commit", "-m", cmt])
                        proc.run(["git", "-C", dir, "push"])
            elif "b" in opts:
                if ask_user(msg11, opts, True):
                    proc.run(["git", "-C", dir, "restore", "--staged", dir])
                    proc.run(["git", "-C", dir, "restore", dir])
                    proc.run(["git", "-C", dir, "clean", "-fdq"])


def help_msg():
    print("""  Flag options:
- c         commit, pull, push if possible
- d         show diffs
- f         forcely allow dangerous operations
- v         show verbose output
- y         always answer yes to questions

  Action options:
- b         restore backup
- e         edit config, init files
- h         show help message
- i         initialize necessary directories and files
- r         run init scripts
- s         save tracked files

  Shortcuts:
save        -s -cvy
restore     -b -vy
init        -r -y
edit        -e -y
help        -h

            """)


def init_files():
    for dir in DIRS.values():
        if not os.path.exists(dir):
            os.makedirs(dir)
    for file in FILES.values():
        if not os.path.exists(file):
            open(file, 'w').close()


def edit(opts):
    for file in itt.chain([SCRIPT_PATH], FILES.values(), get_inits()):
        if os.path.exists(file):
            msg = color("msg", "Do you really want to edit ", False)
            msg += color("file", os.path.relpath(file, SCRIPT_DIR), False)
            msg += color("msg", " ? ", False)
            if ask_user(msg, opts):
                proc.run(["nvim", file])


def run(opts):
    for file in get_inits():
        msg = color("msg", "Do you really want to execute ", False)
        msg += color("file", os.path.relpath(file, SCRIPT_DIR), False)
        msg += color("msg", " ? ", False)
        if ask_user(msg, opts):
            os.chmod(file, os.stat(file).st_mode | 0o111)
            if proc.run(file).returncode != 0:
                color("err", "ERROR: init script failed!\n")
                exit(1)


# EXECUTION FUNCTIONS
def parse_options():
    args = sys.argv[1:]
    if len(args) == 1:
        match args[0]:
            case "save": return ['s', 'c', 'v', 'y']
            case "restore": return ['b', 'v', 'y']
            case "init": return ['r', 'y']
            case "edit": return ['e', 'y']
            case "help": return ['h']
    try:
        args = [s for s in args if s.startswith("-")]
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
        case "b" | "s" | None: backup(opts)
        case "e": edit(opts)
        case "h": help_msg()
        case "i": init_files()
        case "r": run(opts)


# ACTUAL EXECUTION
if __name__ == "__main__":
    execute(parse_options())
