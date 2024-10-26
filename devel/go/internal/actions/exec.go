package actions

import (
	"autosaver/internal/utils"
)

var scriptDir string = utils.ScriptDir
var backupDir string = utils.AllDirs[utils.DirBackup]
var runDir string = utils.AllDirs[utils.DirRun]
var configDir string = utils.AllDirs[utils.DirConfig]

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
		initAction()
	case utils.ActRun:
		runAction(flags)
	}
}

func autoAnswer(f *utils.Flag) utils.Answer {
	autoAnswer := utils.AnsNone
	if f.HasOptionFlag(utils.OptYes) {
		autoAnswer = utils.AnsYes
	}
	if f.HasOptionFlag(utils.OptNo) {
		autoAnswer = utils.AnsNo
	}
	return autoAnswer
}
