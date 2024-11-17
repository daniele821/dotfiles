package configs

import (
	"fmt"
	"strings"
)

func (option Option) String() string {
	switch option {
	case OptDiff:
		return "OptDiff"
	case OptForce:
		return "OptForce"
	case OptNo:
		return "OptNo"
	case OptYes:
		return "OptYes"
	case OptToggle:
		return "OptToggle"
	case OptVerbose:
		return "OptVerbose"
	}
	return fmt.Sprintf("Option(%d)", option)
}

func (action Action) String() string {
	switch action {
	case ActList:
		return "ActList"
	case ActUntracked:
		return "ActUntracked"
	case ActSave:
		return "ActSave"
	case ActBackup:
		return "ActBackup"
	case ActCommit:
		return "ActCommit"
	case ActEdit:
		return "ActEdit"
	case ActInit:
		return "ActInit"
	case ActRun:
		return "ActRun"
	}
	return fmt.Sprintf("Action(%d)", action)
}

func (flag Flag) String() string {
	acts := strings.Builder{}
	opts := strings.Builder{}
	for _, act := range flag.actionFlags {
		acts.WriteString(act.String())
		acts.WriteString(" ")
	}
	for _, opt := range flag.optionFlags {
		opts.WriteString(opt.String())
		opts.WriteString(" ")
	}
	actsStr := strings.TrimSpace(acts.String())
	optsStr := strings.TrimSpace(opts.String())
	return fmt.Sprintf("Flag -> Actions: [%s], Options: [%s]", actsStr, optsStr)
}

func (typeDir typeDir) String() string {
	switch typeDir {
	case DirBackup:
		return "DirBackup"
	case DirRun:
		return "DirRun"
	case DirOther:
		return "DirOther"
	case DirConfig:
		return "DirConfig"
	}
	return fmt.Sprintf("typeDir(%d)", typeDir)
}

func (typeFile typeFile) String() string {
	switch typeFile {
	case FileTrack:
		return "FileTrack"
	case FileNotDiff:
		return "FileNotDiff"
	}
	return fmt.Sprintf("typeFile(%d)", typeFile)
}
