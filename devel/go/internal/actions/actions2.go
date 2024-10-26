package actions

import "autosaver/internal/utils"

func initAction(flag *utils.Flag) {}

func runAction(flag *utils.Flag) {}

func editAction(flag *utils.Flag) {}

// def init_files():
//     for dir in DIRS.values():
//         if not os.path.exists(dir):
//             create_dir(dir)
//     for file in FILES.values():
//         if not os.path.exists(file):
//             create_file(file)
//
//
// def run_files(opts):
//     msg1 = color("msg", "Do you really want to execute ")
//     msg3 = color("msg", " ? ")
//     for file in sorted(all_files(DIRS["run"])):
//         msg2 = color("file", os.path.relpath(file, SCRIPT_DIR))
//         if ask_user(msg1+msg2+msg3, opts):
//             if not os.access(file, os.X_OK):
//                 error("file is not executable!")
//             if not run_and_get_status(file):
//                 error("init script failed!")
//
//
// def edit_files(opts):
//     msg1 = color("msg", "Do you really want to edit ")
//     msg3 = color("msg", " ? ")
//     files = [SCRIPT_PATH] + list(FILES.values()) + \
//         sorted(all_files(DIRS["run"]))
//     for file in files:
//         if os.path.isfile(file):
//             msg2 = color("file", os.path.relpath(file, SCRIPT_DIR))
//             if ask_user(msg1+msg2+msg3, opts):
//                 edit(file)
//
//
