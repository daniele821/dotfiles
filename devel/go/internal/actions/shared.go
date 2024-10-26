package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
)

var scriptDir string = configs.ScriptDir
var backupDir string = configs.AllDirs[configs.DirBackup]
var runDir string = configs.AllDirs[configs.DirRun]
var configDir string = configs.AllDirs[configs.DirConfig]

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

func values[M ~map[K]V, K comparable, V any](m M) []V {
	r := make([]V, 0, len(m))
	for _, v := range m {
		r = append(r, v)
	}
	return r
}
