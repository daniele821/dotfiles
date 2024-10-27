package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"cmp"
	"slices"
)

var dirScript string = configs.ScriptDir
var dirBackup string = configs.AllDirs[configs.DirBackup]
var dirRun string = configs.AllDirs[configs.DirRun]
var dirConfig string = configs.AllDirs[configs.DirConfig]
var dirOther string = configs.AllDirs[configs.DirOther]
var fileTrack string = configs.AllFiles[configs.FileTrack]
var fileNotdiff string = configs.AllFiles[configs.FileNotDiff]

func autoAnswer(f configs.Flag) utils.Answer {
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

func sub[M cmp.Ordered](m1 []M, m2 []M) []M {
	slices.Sort(m1)
	slices.Sort(m2)
	m1 = slices.Compact(m1)
	m2 = slices.Compact(m2)
	var res []M
	for _, m := range m1 {
		if !slices.Contains(m2, m) {
			res = append(res, m)
		}
	}
	slices.Sort(res)
	res = slices.Compact(res)
	return res
}
