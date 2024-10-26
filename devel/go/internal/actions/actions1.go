package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"fmt"
	"path/filepath"
	"slices"
)

func backupAction(flag *configs.Flag) {
	autoAnswer := autoAnswer(flag)
	act := flag.GetActionFlag()
	actSave := act == configs.ActSave
	actBackup := act == configs.ActBackup
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optDiff := flag.HasOptionFlag(configs.OptDiff)
	optForce := flag.HasOptionFlag(configs.OptForce)
	optVerbose := flag.HasOptionFlag(configs.OptVerbose)
	trackedFiles := loadConf(fileTrack)
	notdiffFiles := loadConf(fileNotdiff)
	allFiles := append(trackedFiles, notdiffFiles...)
	slices.Sort(allFiles)
	allFiles = slices.Compact(allFiles)

	fileInfo := func(file, descr string) {
		msgFile := utils.ColorMsg(file, utils.MsgFile)
		if optVerbose {
			fmt.Printf("%s : %s", msgFile, descr)
		}
		fmt.Println(msgFile)
	}

	for _, file := range allFiles {
		homeFile := filepath.Join(configs.Home, file)
		backupFile := filepath.Join(dirBackup, file)
		isHomeFile := utils.IsRegularFile(homeFile)
		isBackupFile := utils.IsRegularFile(backupFile)
		switch {
		case isHomeFile && !isBackupFile:
			fileInfo(homeFile, "backup file is missing")
			if actSave {
				if utils.AskUser(utils.ColorMsg("Do you really want to create backup file ? ", utils.MsgInfo), autoAnswer) {
					utils.CopyFile(homeFile, backupFile)
				}
			}
			if actBackup && optForce {
				if utils.AskUser(utils.ColorMsg("[DANGER] Do you really want to delete original file ? ", utils.MsgInfo), autoAnswer) {
					utils.DeleteFile(homeFile, false)
				}
			}
		case !isHomeFile && isBackupFile:
			fileInfo(homeFile, "backup file is missing")
			if actSave {
				if utils.AskUser(utils.ColorMsg("Do you really want to delete backup file ? ", utils.MsgInfo), autoAnswer) {
					utils.DeleteFile(backupFile, true)
				}
			}
			if actBackup {
				if utils.AskUser(utils.ColorMsg("Do you really want to create original file ? ", utils.MsgInfo), autoAnswer) {
					utils.CopyFile(backupFile, homeFile)
				}
			}
		case isHomeFile && isBackupFile && (optToggle || !slices.Contains(notdiffFiles, file)):
			if utils.ProcessFilesDiffer(homeFile, backupFile) {
				fileInfo(homeFile, "backup file is missing")
				if optDiff {
					if actBackup {
						utils.ProcessDiff(homeFile, backupFile)
					} else {
						utils.ProcessDiff(backupFile, homeFile)
					}
				}
				if actSave {
					if utils.AskUser(utils.ColorMsg("Do you really want to update backup file ? ", utils.MsgInfo), autoAnswer) {
						utils.CopyFile(homeFile, backupFile)
					}
				}
				if actBackup && optForce {
					if utils.AskUser(utils.ColorMsg("Do you really want to update original file ? ", utils.MsgInfo), autoAnswer) {
						utils.CopyFile(backupFile, homeFile)
					}
				}
			}
		}
	}
}

func untrackedAction(flag *configs.Flag) {
	autoAnswer := autoAnswer(flag)
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optForce := flag.HasOptionFlag(configs.OptForce)
	trackedFiles := append(loadConf(fileTrack), loadConf(fileNotdiff)...)
	backupFiles := utils.AllFilesInDir(dirBackup, dirBackup)
	for _, file := range sub(backupFiles, trackedFiles) {
		homeFile := filepath.Join(configs.Home, file)
		backupFile := filepath.Join(dirBackup, file)
		fmt.Println(utils.ColorMsg(homeFile, utils.MsgFile))
		if optToggle {
			if utils.AskUser(utils.ColorMsg("Do you really want to delete backup file ? ", utils.MsgInfo), autoAnswer) {
				utils.DeleteFile(backupFile, true)
			}
			if optForce && utils.IsRegularFile(homeFile) {
				if utils.AskUser(utils.ColorMsg("[DANGER] Do you really want to delete original file ? ", utils.MsgInfo), autoAnswer) {
					utils.DeleteFile(homeFile, true)
				}
			}
		}
	}
}

func commitAction(flag *configs.Flag) {
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optDiff := flag.HasOptionFlag(configs.OptDiff)
	autoAnswer := autoAnswer(flag)

	if !optToggle {
		utils.ProcessGitPull(dirScript)
	}

	if utils.ProcessHasGitChanges(dirScript) {
		if optDiff {
			utils.ProcessGitDiff(dirScript, optToggle)
		}
		utils.ProcessGitStatus(dirScript)
		if !optToggle {
			if utils.AskUser(utils.ColorMsg("Do you really want to commit all? ", utils.MsgInfo), autoAnswer) {
				fmt.Print(utils.ColorMsg("Write commit message: ", utils.MsgInfo))
				input := utils.ReadInput()
				if input != "" {
					utils.ProcessGitCommitAll(dirScript, input)
				}
			}
		} else {
			if utils.AskUser(utils.ColorMsg("Do you really want to restore all? ", utils.MsgInfo), autoAnswer) {
				utils.ProcessGitRestoreAll(dirScript)
			}
		}
	} else if optToggle {
		utils.ProcessGitRestoreAll(dirScript)
	}

	if !optToggle {
		utils.ProcessGitPush(dirScript)
	}
}
