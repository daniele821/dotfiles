package utils

import (
	"os"
	"path/filepath"
)

type Action int
type Option int
type TypeDir int
type TypeFile int

const (
	ActList Action = iota + 1
	ActUntracked
	ActSave
	ActBackup
	ActCommit
	ActEdit
	ActInit
	ActRun
	ActDefault Action = ActList
)

const (
	OptDiff Option = iota + 1
	OptForce
	OptNo
	OptYes
	OptToggle
	OptVerbose
)

const (
	DirBackup TypeDir = iota + 1
	DirRun
	DirOther
	DirConfig
)

const (
	FileTrack TypeFile = iota + 1
	FileNotDiff
)

var (
	Home       string = home()
	ScriptPath string = scriptPath()
	ScriptDir  string = filepath.Dir(ScriptPath)
)
var (
	AllDirs = map[TypeDir]string{
		DirBackup: filepath.Join(ScriptDir, "backup"),
		DirRun:    filepath.Join(ScriptDir, "run"),
		DirOther:  filepath.Join(ScriptDir, "others"),
		DirConfig: filepath.Join(ScriptDir, "config"),
	}
	AllFiles = map[TypeFile]string{
		FileTrack:   filepath.Join(AllDirs[DirConfig], "files_to_track.txt"),
		FileNotDiff: filepath.Join(AllDirs[DirConfig], "files_to_notdiff.txt"),
	}
)

func home() string {
	home, err := os.UserHomeDir()
	if err != nil {
		errExit("could not get user home directory")
	}
	return home
}

func scriptPath() string {
	path, err := os.Executable()
	if err != nil {
		errExit("could not get path of current executable")
	}
	path, err = filepath.EvalSymlinks(path)
	if err != nil {
		errExit("could not solve symlink path of current executable")
	}
	return path
}

// TODO: shortcuts
// SHORTCUTS = {
//     "save": [["-svy"]],
//     "restore": [["-bvy"]],
//     "saveall": [["-svyt"]],
//     "restoreall": [["-bvyt"]],
//     "commit": [["-cy"]],
//     "uncommit": [["-cty"]],
//     "untracked": [["-u"]],
//     "init": [["-iy"]],
//     "run": [["-ry"]],
//     "edit": [["-e"]],
// }
// SHORTCUTS |= {"co": [SHORTCUTS["commit"][0]]}
// SHORTCUTS |= {"un": [SHORTCUTS["uncommit"][0]]}
// SHORTCUTS |= {"sc": [SHORTCUTS["save"][0], SHORTCUTS["commit"][0]]}
