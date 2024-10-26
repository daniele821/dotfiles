package actions

import (
	"autosaver/internal/utils"
	"slices"
)

func initAction() {
	for _, dir := range utils.AllDirs {
		utils.CreateDir(dir)
	}
	for _, file := range utils.AllFiles {
		utils.CreateFile(file)
	}
}

func runAction(flag *utils.Flag) {
	files := utils.AllFilesInDir(utils.AllDirs[utils.DirRun], "")
	slices.Sort(files)
}

func editAction(flag *utils.Flag) {}

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
