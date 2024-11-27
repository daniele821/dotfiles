package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"fmt"
	"path/filepath"
	"slices"
)

func loadAllConf() (allTrackedFiles, allNotdiffFiles, AllFiles []string) {
	trackedFiles := loadConf(fileTrack, utils.FileTypeFileRegular)
	notdiffFiles := loadConf(fileNotdiff, utils.FileTypeFileRegular)
	trackedFilesLink := loadConf(fileTrackLink, utils.FileTypeFile)
	notdiffFilesLink := loadConf(fileNotdiffLink, utils.FileTypeFile)
	allTracked := append(trackedFiles, trackedFilesLink...)
	allNotdiff := append(notdiffFiles, notdiffFilesLink...)
	allFiles := append(allTracked, allNotdiff...)
	slices.Sort(allFiles)
	allFiles = slices.Compact(allFiles)

	return allTracked, allNotdiff, allFiles
}

func backupAction(flag configs.Flag) {
	autoAnswer := autoAnswer(flag)
	act := flag.GetActionFlag()
	actSave := act == configs.ActSave
	actBackup := act == configs.ActBackup
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optDiff := flag.HasOptionFlag(configs.OptDiff)
	optForce := flag.HasOptionFlag(configs.OptForce)
	optVerbose := flag.HasOptionFlag(configs.OptVerbose)
	_, allNotdiffFiles, allFiles := loadAllConf()

	fileInfo := func(file, descr string) {
		msgFile := utils.ColorMsg(file, utils.MsgFile)
		if optVerbose {
			fmt.Printf("%s : %s\n", msgFile, descr)
		} else {
			fmt.Println(msgFile)
		}
	}

	for _, file := range allFiles {
		homeFile := filepath.Join(configs.Home, file)
		backupFile := filepath.Join(dirBackup, file)
		isHomeFile := utils.FileTypeFile.Check(homeFile)
		isBackupFile := utils.FileTypeFile.Check(backupFile)
		switch {
		case isHomeFile && !isBackupFile:
			fileInfo(homeFile, "backup file is missing")
			if actSave {
				if utils.AskUser(utils.ColorMsg("Do you really want to create backup file ? ", utils.MsgInfo), autoAnswer...) {
					utils.CopyFile(homeFile, backupFile)
				}
			}
			if actBackup && optForce {
				if utils.AskUser(utils.ColorMsg("[DANGER] Do you really want to delete original file ? ", utils.MsgInfo), autoAnswer...) {
					utils.DeleteFile(homeFile, false)
				}
			}
		case !isHomeFile && isBackupFile:
			fileInfo(homeFile, "original file is missing")
			if actSave {
				if utils.AskUser(utils.ColorMsg("Do you really want to delete backup file ? ", utils.MsgInfo), autoAnswer...) {
					utils.DeleteFile(backupFile, true)
				}
			}
			if actBackup {
				if utils.AskUser(utils.ColorMsg("Do you really want to create original file ? ", utils.MsgInfo), autoAnswer...) {
					utils.CopyFile(backupFile, homeFile)
				}
			}
		case isHomeFile && isBackupFile && (optToggle || !slices.Contains(allNotdiffFiles, file)):
			if utils.FilesDiffer(homeFile, backupFile) {
				fileInfo(homeFile, "backup and original files differ")
				if optDiff {
					if actBackup {
						utils.ProcessDiff(homeFile, backupFile)
					} else {
						utils.ProcessDiff(backupFile, homeFile)
					}
				}
				if actSave {
					if utils.AskUser(utils.ColorMsg("Do you really want to update backup file ? ", utils.MsgInfo), autoAnswer...) {
						utils.CopyFile(homeFile, backupFile)
					}
				}
				if actBackup {
					if utils.AskUser(utils.ColorMsg("Do you really want to update original file ? ", utils.MsgInfo), autoAnswer...) {
						utils.CopyFile(backupFile, homeFile)
					}
				}
			}
		}
	}
}

func untrackedAction(flag configs.Flag) {
	autoAnswer := autoAnswer(flag)
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optForce := flag.HasOptionFlag(configs.OptForce)
	_, _, trackedFiles := loadAllConf()
	backupFiles := utils.AllFilesInDir(dirBackup, dirBackup, utils.FileTypeFile)
	for _, file := range utils.Sub(backupFiles, trackedFiles) {
		homeFile := filepath.Join(configs.Home, file)
		backupFile := filepath.Join(dirBackup, file)
		fmt.Println(utils.ColorMsg(homeFile, utils.MsgFile))
		if optToggle {
			if utils.AskUser(utils.ColorMsg("Do you really want to delete backup file ? ", utils.MsgInfo), autoAnswer...) {
				utils.DeleteFile(backupFile, true)
			}
			if optForce && utils.FileTypeFile.Check(homeFile) {
				if utils.AskUser(utils.ColorMsg("[DANGER] Do you really want to delete original file ? ", utils.MsgInfo), autoAnswer...) {
					utils.DeleteFile(homeFile, true)
				}
			}
		}
	}
}

func commitAction(flag configs.Flag) {
	optToggle := flag.HasOptionFlag(configs.OptToggle)
	optDiff := flag.HasOptionFlag(configs.OptDiff)
	autoAnswer := autoAnswer(flag)
	gitRootDir := utils.ProcessGitRootDir(dirScript)

	if !optToggle {
		utils.ProcessGitPull(gitRootDir)
	}

	if utils.ProcessHasGitChanges(gitRootDir) {
		if optDiff {
			utils.ProcessGitDiff(gitRootDir, optToggle)
		}
		utils.ProcessGitStatus(gitRootDir)
		if !optToggle {
			if utils.AskUser(utils.ColorMsg("Do you really want to commit all? ", utils.MsgInfo), autoAnswer...) {
				fmt.Print(utils.ColorMsg("Write commit message: ", utils.MsgInfo))
				input := utils.ReadInput()
				if input != "" {
					utils.ProcessGitCommitAll(gitRootDir, input)
				}
			}
		} else {
			if utils.AskUser(utils.ColorMsg("Do you really want to restore all? ", utils.MsgInfo), autoAnswer...) {
				utils.ProcessGitRestoreAll(gitRootDir)
			}
		}
	} else if optToggle {
		utils.ProcessGitRestoreAll(gitRootDir)
	}

	if !optToggle {
		utils.ProcessGitPush(gitRootDir)
	}
}
