#!/bin/python3

import os
from filecmp import cmp
from sys import argv
from enum import Enum
from pathlib import Path
from lib.file import read_file, all_files, create_file, create_dir, \
    copy_file, delete_file
from lib.msg import error, color, ask_user
from lib.procs import run_and_get_status, edit, diff, git_pull, git_push, \
    git_status, git_restore_all, git_diff, git_commit_all, has_git_changed

HOME = Path.home()
SCRIPT_PATH = os.path.realpath(__file__)
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
DIRS = {"backup": os.path.join(SCRIPT_DIR, "backup"),
        "config": os.path.join(SCRIPT_DIR, "config"),
        "run": os.path.join(SCRIPT_DIR, "run"),
        "others": os.path.join(SCRIPT_DIR, "others")}
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
    "save": [["-svy"]],
    "restore": [["-bvy"]],
    "commit": [["-cy"]],
    "uncommit": [["-cty"]],
    "untracked": [["-u"]],
    "init": [["-iy"]],
    "run": [["-ry"]],
    "edit": [["-e"]],
    "sc": [["-svy"], ["-cy"]],
}


def load_config(conf):
    odir = HOME
    bdir = DIRS["backup"]
    files = set()
    if os.path.isfile(conf):
        for line in read_file(conf).splitlines():
            if not line.startswith("/") and line:
                ofile = os.path.join(odir, line)
                bfile = os.path.join(bdir, line)
                for file, dir in ((ofile, odir), (bfile, bdir)):
                    if os.path.isfile(file):
                        files.add(line)
                    elif os.path.isdir(file):
                        files.update(all_files(file, dir))
    return files


def backup_files(act, opts, ans):
    odir = HOME
    bdir = DIRS["backup"]
    act_save = act == ACTIONS.SAVE
    act_backup = act == ACTIONS.BACKUP
    opt_toggle = FLAGS.TOGGLE in opts
    opt_diff = FLAGS.DIFF in opts
    opt_force = FLAGS.FORCE in opts
    opt_verbose = FLAGS.VERBOSE in opts
    tracked = load_config(FILES["track"])
    notdiff = load_config(FILES["notdiff"])
    all = sorted(tracked | notdiff)

    def qmsg(act, on,  prefix=""):
        res = prefix + "Do you really want to " + act + " " + on + " file? "
        return color("msg", res)

    def fout(file, on=None, stat=None):
        msg_file = color("file", file)
        if opt_verbose and on and stat:
            print(msg_file + " : " + on + " " + stat)
        else:
            print(msg_file)

    for file in all:
        ofile = os.path.join(odir, file)
        bfile = os.path.join(bdir, file)
        match os.path.isfile(ofile), os.path.isfile(bfile):
            case True, False:
                fout(ofile, "backup file", "is missing")
                if act_save:
                    if ask_user(qmsg("create", "backup"), ans):
                        copy_file(ofile, bfile)
                if act_backup and opt_force:
                    if ask_user(qmsg("delete", "original", "[DANGER] "), ans):
                        delete_file(ofile)
            case False, True:
                fout(ofile, "original file", "is missing")
                if act_save:
                    if ask_user(qmsg("delete", "backup"), ans):
                        delete_file(bfile, True)
                if act_backup and opt_force:
                    if ask_user(qmsg("create", "original"), ans):
                        copy_file(bfile, ofile)
            case True, True:
                if opt_toggle or file not in notdiff:
                    if not cmp(ofile, bfile):
                        fout(ofile, "original and backup files", "differ")
                        if opt_diff:
                            old = bfile if act_save else ofile
                            new = ofile if act_save else bfile
                            diff(old, new)
                    if act_save:
                        if ask_user(qmsg("update", "backup"), ans):
                            copy_file(ofile, bfile)
                    if act_backup and opt_force:
                        if ask_user(qmsg("update", "original"), ans):
                            copy_file(bfile, ofile)


def commit_files(opts, auto_answer):
    opt_toggle = FLAGS.TOGGLE in opts
    opt_diff = FLAGS.DIFF in opts
    msg_commit = color("msg", "Do you really want to commit all? ")
    msg_restore = color("msg", "Do you really want to restore all? ")
    if not opt_toggle:
        git_pull(SCRIPT_DIR)
    if has_git_changed(SCRIPT_DIR):
        if opt_diff:
            git_diff(SCRIPT_DIR, reverse=opt_toggle)
        git_status(SCRIPT_DIR)
        if opt_toggle:
            if ask_user(msg_restore, auto_answer):
                git_restore_all(SCRIPT_DIR)
        else:
            if ask_user(msg_commit, auto_answer):
                if commit_msg := input(color("msg", "Write commit message: ")):
                    git_commit_all(SCRIPT_DIR, commit_msg)
    if not opt_toggle:
        git_push(SCRIPT_DIR)


def init_files():
    for dir in DIRS.values():
        if not os.path.exists(dir):
            create_dir(dir)
    for file in FILES.values():
        if not os.path.exists(file):
            create_file(file)


def run_files(auto_answer):
    msg1 = color("msg", "Do you really want to execute ")
    msg3 = color("msg", " ? ")
    for file in sorted(all_files(DIRS["run"])):
        msg2 = color("file", os.path.relpath(file, SCRIPT_DIR))
        if ask_user(msg1+msg2+msg3, auto_answer):
            if not os.access(file, os.X_OK):
                error("file is not executable!")
            if not run_and_get_status(file):
                error("init script failed!")


def edit_files(auto_answer):
    msg1 = color("msg", "Do you really want to edit ")
    msg3 = color("msg", " ? ")
    files = [SCRIPT_PATH] + list(FILES.values()) + \
        sorted(all_files(DIRS["run"]))
    for file in files:
        if os.path.isfile(file):
            msg2 = color("file", os.path.relpath(file, SCRIPT_DIR))
            if ask_user(msg1+msg2+msg3, auto_answer):
                edit(file)


def parse_shortcuts(args):
    args = "".join(args)
    if args in SHORTCUTS:
        return [parse_options(x) for x in SHORTCUTS[args]]


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


def execute(flags):
    act, opts = flags
    auto_answer = None
    if FLAGS.NO in opts:
        auto_answer = "n"
    elif FLAGS.YES in opts:
        auto_answer = "y"
    match act:
        case ACTIONS.LIST | ACTIONS.SAVE | ACTIONS.BACKUP:
            backup_files(act, opts, auto_answer)
        case ACTIONS.UNTRACKED: pass
        case ACTIONS.COMMIT: commit_files(opts, auto_answer)
        case ACTIONS.EDIT: edit_files(auto_answer)
        case ACTIONS.INIT: init_files()
        case ACTIONS.RUN: run_files(auto_answer)


if __name__ == "__main__":
    args = argv[1:]
    flags = parse_shortcuts(args)
    if flags is None:
        flags = [parse_options(args)]
    for flag in flags:
        execute(flag)
