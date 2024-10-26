package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
)

var scriptDir string = configs.ScriptDir
var backupDir string = configs.AllDirs[configs.DirBackup]
var runDir string = configs.AllDirs[configs.DirRun]
var configDir string = configs.AllDirs[configs.DirConfig]

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
		initAction()
	case configs.ActRun:
		runAction(flags)
	}
}

func autoAnswer(f *configs.Flag) utils.Answer {
	autoAnswer := utils.AnsNone
	if f.HasOptionFlag(configs.OptYes) {
		autoAnswer = utils.AnsYes
	}
	if f.HasOptionFlag(configs.OptNo) {
		autoAnswer = utils.AnsNo
	}
	return autoAnswer
}
