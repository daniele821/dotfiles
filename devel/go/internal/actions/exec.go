package actions

import (
	"autosaver/internal/configs"
)

func Execute(flags *configs.Flag) {
	switch flags.GetActionFlag() {
	case configs.ActList, configs.ActSave, configs.ActBackup:
		backupAction(flags)
	case configs.ActUntracked:
		untrackedAction(flags)
	case configs.ActCommit:
		commitAction(flags)
	case configs.ActEdit:
		editAction(flags)
	case configs.ActInit:
		initAction(flags)
	case configs.ActRun:
		runAction(flags)
	}
}
