package actions

import "autosaver/internal/utils"

func Execute(flags *utils.Flag) {
	switch flags.GetActionFlag() {
	case utils.ActList, utils.ActSave, utils.ActBackup:
		backupAction(flags)
	case utils.ActUntracked:
		untrackedAction(flags)
	case utils.ActCommit:
		commitAction(flags)
	case utils.ActEdit:
		editAction(flags)
	case utils.ActInit:
		initAction(flags)
	case utils.ActRun:
		runAction(flags)
	}
}
