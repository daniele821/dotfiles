package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"path/filepath"
	"slices"
)

func initAction() {
	for _, dir := range configs.AllDirs {
		utils.CreateDir(dir)
	}
	for _, file := range configs.AllFiles {
		if !utils.IsRegularFile(file) {
			utils.CreateFile(file)
		}
	}
}

func runAction(flag *configs.Flag) {
	autoAnswer := autoAnswer(flag)
	files := utils.AllFilesInDir(runDir, "")
	slices.Sort(files)
	msg1 := utils.ColorMsg("Do you really want to execute ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	for _, file := range files {
		relfile, _ := filepath.Rel(scriptDir, file)
		msg2 := utils.ColorMsg(relfile, utils.MsgFile)
		if utils.AskUser(msg1+msg2+msg3, autoAnswer) {
			if !utils.ProcessExecute(file) {
				utils.ErrExit("init script failed!")
			}
		}
	}
}

func values[M ~map[K]V, K comparable, V any](m M) []V {
	r := make([]V, 0, len(m))
	for _, v := range m {
		r = append(r, v)
	}
	return r
}

func editAction(flag *configs.Flag) {
	autoAnswer := autoAnswer(flag)
	msg1 := utils.ColorMsg("Do you really want to execute ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	files := utils.AllFilesInDir(runDir, "")
	files = append(files, values(configs.AllFiles)...)
	slices.Sort(files)
	for _, file := range files {
		if utils.IsRegularFile(file) {
			relfile, _ := filepath.Rel(scriptDir, file)
			msg2 := utils.ColorMsg(relfile, utils.MsgFile)
			if utils.AskUser(msg1+msg2+msg3, autoAnswer) {
				utils.ProcessEdit(file)
			}
		}
	}
}
