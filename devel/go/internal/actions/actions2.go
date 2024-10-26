package actions

import (
	"autosaver/internal/utils"
	"slices"
)

func initAction() {
	for _, dir := range utils.AllDirs {
		utils.CreateDir(dir)
	}
	for _, file := range utils.AllFiles {
		utils.CreateFile(file)
	}
}

func runAction(flag *utils.Flag) {
	autoAnswer := autoAnswer(flag)
	files := utils.AllFilesInDir(utils.AllDirs[utils.DirRun], "")
	slices.Sort(files)
	msg1 := utils.ColorMsg("Do you really want to execute ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	for _, file := range files {
		msg2 := utils.ColorMsg(file, utils.MsgFile)
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

func editAction(flag *utils.Flag) {
	autoAnswer := autoAnswer(flag)
	msg1 := utils.ColorMsg("Do you really want to execute ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	files := utils.AllFilesInDir(utils.AllDirs[utils.DirRun], "")
	files = append(files, values(utils.AllFiles)...)
	files = append(files, utils.ScriptPath)
	slices.Sort(files)
	for _, file := range files {
		if utils.IsRegularFile(file) {
			msg2 := utils.ColorMsg(file, utils.MsgFile)
			if utils.AskUser(msg1+msg2+msg3, autoAnswer) {
				utils.ProcessEdit(file)
			}
		}
	}
}
