package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
)

var dirScript string = configs.ScriptDir
var dirBackup string = configs.AllDirs[configs.DirBackup]
var dirRun string = configs.AllDirs[configs.DirRun]
var dirConfig string = configs.AllDirs[configs.DirConfig]
var dirOther string = configs.AllDirs[configs.DirOther]
var fileTrack string = configs.AllFiles[configs.FileTrack]
var fileNotdiff string = configs.AllFiles[configs.FileNotDiff]
var fileTrackLink string = configs.AllFiles[configs.FileTrackLink]
var fileNotdiffLink string = configs.AllFiles[configs.FileNotDiffLink]

func autoAnswer(f configs.Flag) []utils.Answer {
	if f.HasOptionFlag(configs.OptNo) {
		return []utils.Answer{utils.AnsNo}
	}
	if f.HasOptionFlag(configs.OptYes) {
		return []utils.Answer{utils.AnsYes}
	}
	return nil
}
