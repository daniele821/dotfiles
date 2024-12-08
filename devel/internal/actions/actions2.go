package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"fmt"
	"path/filepath"
	"slices"
	"strings"
)

func initAction(flag configs.Flag) {
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optForce := flag.HasOptionFlag(configs.OptForce)
	if optToggle {
		for _, file := range configs.AllFiles {
			utils.DeleteFile(file, false)
		}
		for _, dir := range configs.AllDirs {
			utils.DeleteDir(dir, optForce)
		}
	} else {
		for _, dir := range configs.AllDirs {
			utils.CreateDir(dir)
		}
		for _, file := range configs.AllFiles {
			utils.CreateFile(file)
		}
	}
}

func runAction(flag configs.Flag) {
	autoAnswer := autoAnswer(flag)
	files := utils.AllFilesInDir(dirRun, "", utils.FileTypeFileRegular)
	slices.Sort(files)
	msg1 := utils.ColorMsg("Do you really want to execute ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	for _, file := range files {
		relfile, _ := filepath.Rel(dirScript, file)
		msg2 := utils.ColorMsg(relfile, utils.MsgFile)
		if utils.AskUser(msg1+msg2+msg3, autoAnswer...) {
			if !utils.ProcessExecute(file) {
				utils.ErrExit("init script failed!")
			}
		}
	}
}

func editAction(flag configs.Flag) {
	autoAnswer := autoAnswer(flag)
	msg1 := utils.ColorMsg("Do you really want to edit ", utils.MsgInfo)
	msg3 := utils.ColorMsg(" ? ", utils.MsgInfo)
	files := utils.AllFilesInDir(dirRun, "", utils.FileTypeFileRegular)
	files = append(files, utils.Values(configs.AllFiles)...)
	slices.Sort(files)
	for _, file := range files {
		if utils.FileTypeFileRegular.Check(file) {
			relfile, _ := filepath.Rel(dirScript, file)
			msg2 := utils.ColorMsg(relfile, utils.MsgFile)
			if utils.AskUser(msg1+msg2+msg3, autoAnswer...) {
				utils.ProcessEdit(file)
			}
		}
	}
}

func helpAction() {
	if !utils.FileTypeFileRegular.Check(configs.HelpPath) {
		help, _ := filepath.Rel(dirScript, configs.HelpPath)
		utils.ErrExit("%s is missing!", help)
	} else {
		file := utils.ReadFile(configs.HelpPath)
		fileSplit := strings.Split(file, "*")
		for index, i := range fileSplit {
			if index%2 == 0 {
				fmt.Print(i)
			} else {
				fmt.Printf("\x1b[m\x1b[%sm", i)
			}
		}
	}
}
