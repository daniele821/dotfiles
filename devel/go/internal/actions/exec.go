package actions

import "autosaver/internal/utils"

func Execute(flags *utils.Flag) {
	switch flags.GetActionFlag() {
	case utils.ActList, utils.ActSave, utils.ActBackup:
	case utils.ActUntracked:
	case utils.ActCommit:
	case utils.ActEdit:
	case utils.ActInit:
	case utils.ActRun:
	}
}
