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

func ShortcutToFlag(shortcut string) *Flag {
	var flag *Flag = NewFlags(nil, nil)
	switch shortcut {
	case "save":
		flag.AppendFlags([]Action{ActSave}, []Option{OptYes, OptVerbose})
	case "saveall":
		flag.AppendFlags([]Action{ActSave}, []Option{OptYes, OptVerbose, OptToggle})
	case "restore":
		flag.AppendFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose})
	case "restoreall":
		flag.AppendFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose, OptToggle})
	case "commit", "co":
		flag.AppendFlags([]Action{ActCommit}, []Option{OptYes})
	case "uncommit", "un":
		flag.AppendFlags([]Action{ActCommit}, []Option{OptYes, OptToggle})
	case "untracked":
		flag.AppendFlags([]Action{ActUntracked}, []Option{})
	case "init":
		flag.AppendFlags([]Action{ActInit}, []Option{OptYes})
	case "run":
		flag.AppendFlags([]Action{ActRun}, []Option{OptYes})
	case "edit":
		flag.AppendFlags([]Action{ActEdit}, []Option{})
	case "sc":
		flag.AppendAllFlags(ShortcutToFlag("save"))
		flag.AppendAllFlags(ShortcutToFlag("commit"))
	}
	return flag
}
