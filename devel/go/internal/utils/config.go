package utils

import (
	"os"
	"path/filepath"
)

type Action int
type Option int
type typeDir int
type typeFile int

const (
	ActList Action = iota + 1
	ActUntracked
	ActSave
	ActBackup
	ActCommit
	ActEdit
	ActInit
	ActRun
	ActDefault = ActList
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
var (
	ParseShortcut = map[string]*Flag{
		"save":       NewFlags([]Action{ActSave}, []Option{OptYes, OptVerbose}),
		"saveall":    NewFlags([]Action{ActSave}, []Option{OptYes, OptVerbose, OptToggle}),
		"restore":    NewFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose}),
		"restoreall": NewFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose, OptToggle}),
		"commit":     NewFlags([]Action{ActCommit}, []Option{OptYes}),
		"uncommit":   NewFlags([]Action{ActCommit}, []Option{OptYes, OptToggle}),
		"untracked":  NewFlags([]Action{ActUntracked}, []Option{}),
		"init":       NewFlags([]Action{ActInit}, []Option{OptYes}),
		"run":        NewFlags([]Action{ActRun}, []Option{OptYes}),
		"edit":       NewFlags([]Action{ActEdit}, []Option{}),
	}
	ParseAction = map[string]Action{
		"b": ActBackup,
		"c": ActCommit,
		"e": ActEdit,
		"i": ActInit,
		"r": ActRun,
		"s": ActSave,
		"u": ActUntracked,
	}
	ParseOption = map[string]Option{
		"d": OptDiff,
		"f": OptForce,
		"n": OptNo,
		"t": OptToggle,
		"v": OptVerbose,
		"y": OptYes,
	}
)

func home() string {
	home, err := os.UserHomeDir()
	if err != nil {
		ErrExit("could not get user home directory")
	}
	return home
}

func scriptPath() string {
	path, err := os.Executable()
	if err != nil {
		ErrExit("could not get path of current executable")
	}
	path, err = filepath.EvalSymlinks(path)
	if err != nil {
		ErrExit("could not solve symlink path of current executable")
	}
	return path
}
