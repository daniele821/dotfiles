package utils

import (
	"errors"
	"os"
	"path/filepath"
)

type Action int
type Option int
type Shortcut int
type typeDir int
type typeFile int

const (
	ActNone Action = iota
	ActList
	ActUntracked
	ActSave
	ActBackup
	ActCommit
	ActEdit
	ActInit
	ActRun
	ActDefault
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
	ShortcutSave Shortcut = iota + 1
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

func ShortcutToFlag(shortcut Shortcut) *Flag {
	var flag *Flag
	switch shortcut {
	case ShortcutSave:
		flag.AppendFlags([]Action{ActSave}, []Option{OptYes, OptVerbose})
	case ShortcutSaveAll:
		flag.AppendFlags([]Action{ActSave}, []Option{OptYes, OptVerbose, OptToggle})
	case ShortcutRestore:
		flag.AppendFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose})
	case ShortcutRestoreAll:
		flag.AppendFlags([]Action{ActBackup}, []Option{OptYes, OptVerbose, OptToggle})
	case ShortcutCommit:
		flag.AppendFlags([]Action{ActCommit}, []Option{OptYes})
	case ShortcutUncommit:
		flag.AppendFlags([]Action{ActCommit}, []Option{OptYes, OptToggle})
	case ShortcutUntracked:
		flag.AppendFlags([]Action{ActUntracked}, []Option{})
	case ShortcutInit:
		flag.AppendFlags([]Action{ActInit}, []Option{OptYes})
	case ShortcutRun:
		flag.AppendFlags([]Action{ActRun}, []Option{OptYes})
	case ShortcutEdit:
		flag.AppendFlags([]Action{ActEdit}, []Option{})
	}
	return flag
}

func ParseShortcut(shortcut string) (Shortcut, error) {
	switch shortcut {
	case "save":
		return ShortcutSave, nil
	case "saveall":
		return ShortcutSaveAll, nil
	case "restore":
		return ShortcutRestore, nil
	case "restoreall":
		return ShortcutRestoreAll, nil
	case "commit", "co":
		return ShortcutCommit, nil
	case "uncommit", "un":
		return ShortcutUncommit, nil
	case "untracked":
		return ShortcutUntracked, nil
	case "init":
		return ShortcutInit, nil
	case "run":
		return ShortcutRun, nil
	case "edit":
		return ShortcutEdit, nil
	}
	return Shortcut(0), errors.New("not a valid shortcut")
}

func ParseAction(flag string) (Action, error) {
	switch flag {
	case "b":
		return ActBackup, nil
	case "c":
		return ActCommit, nil
	case "e":
		return ActEdit, nil
	case "i":
		return ActInit, nil
	case "r":
		return ActRun, nil
	case "s":
		return ActSave, nil
	case "u":
		return ActUntracked, nil
	}
	return Action(0), errors.New("not a valid action flag")
}

func ParseOption(flag string) (Option, error) {
	switch flag {
	case "d":
		return OptDiff, nil
	case "f":
		return OptForce, nil
	case "n":
		return OptNo, nil
	case "t":
		return OptToggle, nil
	case "v":
		return OptVerbose, nil
	case "y":
		return OptYes, nil
	}
	return Option(0), errors.New("not a valid option flag")
}
