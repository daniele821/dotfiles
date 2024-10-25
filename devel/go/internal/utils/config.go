package utils

import (
	"os"
	"path/filepath"
)

type action int
type option int
type shortcut int
type typeDir int
type typeFile int

const (
	ActList action = iota + 1
	ActUntracked
	ActSave
	ActBackup
	ActCommit
	ActEdit
	ActInit
	ActRun
	ActDefault action = ActList
)
const (
	OptDiff option = iota + 1
	OptForce
	OptNo
	OptYes
	OptToggle
	OptVerbose
)
const (
	ShortcutSave shortcut = iota + 1
	ShortcutSaveAll
	ShortcutRestore
	ShortcutRestoreAll
	ShortcutCommit
	ShortcutUncommit
	ShortcutUntracked
	ShortcutInit
	ShortcutRun
	ShortcutEdit
)
const (
	DirBackup typeDir = iota + 1
	DirRun
	DirOther
	DirConfig
)
const (
	FileTrack typeFile = iota + 1
	FileNotDiff
)

var (
	Home       string = home()
	ScriptPath string = scriptPath()
	ScriptDir  string = filepath.Dir(ScriptPath)
)
var (
	AllDirs = map[typeDir]string{
		DirBackup: filepath.Join(ScriptDir, "backup"),
		DirRun:    filepath.Join(ScriptDir, "run"),
		DirOther:  filepath.Join(ScriptDir, "others"),
		DirConfig: filepath.Join(ScriptDir, "config"),
	}
	AllFiles = map[typeFile]string{
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

func ShortcutToFlag(shortcut shortcut) *flag {
	var flag *flag = NewFlags(nil, nil)
	switch shortcut {
	case ShortcutSave:
		flag.AppendFlags([]action{ActSave}, []option{OptYes, OptVerbose})
	case ShortcutSaveAll:
		flag.AppendFlags([]action{ActSave}, []option{OptYes, OptVerbose, OptToggle})
	case ShortcutRestore:
		flag.AppendFlags([]action{ActBackup}, []option{OptYes, OptVerbose})
	case ShortcutRestoreAll:
		flag.AppendFlags([]action{ActBackup}, []option{OptYes, OptVerbose, OptToggle})
	case ShortcutCommit:
		flag.AppendFlags([]action{ActCommit}, []option{OptYes})
	case ShortcutUncommit:
		flag.AppendFlags([]action{ActCommit}, []option{OptYes, OptToggle})
	case ShortcutUntracked:
		flag.AppendFlags([]action{ActUntracked}, []option{})
	case ShortcutInit:
		flag.AppendFlags([]action{ActInit}, []option{OptYes})
	case ShortcutRun:
		flag.AppendFlags([]action{ActRun}, []option{OptYes})
	case ShortcutEdit:
		flag.AppendFlags([]action{ActEdit}, []option{})
	}
	return flag
}
