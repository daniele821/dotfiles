package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"fmt"
	"path/filepath"
	"slices"
)

func backupAction(flag *configs.Flag) {
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

	println(actSave, actBackup, optToggle, optDiff, optVerbose, optForce)

	for _, file := range allFiles {
		homeFile := filepath.Join(configs.Home, file)
		backupFile := filepath.Join(dirBackup, file)
		isHomeFile := utils.IsRegularFile(homeFile)
		isBackupFile := utils.IsRegularFile(backupFile)
		switch {
		case !isHomeFile && isBackupFile:
			// todo
		case isHomeFile && !isBackupFile:
			// todo
		case isHomeFile && isBackupFile && (optToggle || !slices.Contains(notdiffFiles, file)):
			if utils.ProcessFilesDiffer(homeFile, backupFile) {
				// todo
			}
		}
	}

	//	    match os.path.isfile(ofile), os.path.isfile(bfile):
	//	        case True, False:
	//	            fout(ofile, "backup file", "is missing")
	//	            if act_save:
	//	                if ask_user(qmsg("create", "backup"), opts):
	//	                    copy_file(ofile, bfile)
	//	            if act_backup and opt_force:
	//	                if ask_user(qmsg("delete", "original", "[DANGER] "), opts):
	//	                    delete_file(ofile)
	//	        case False, True:
	//	            fout(ofile, "original file", "is missing")
	//	            if act_save:
	//	                if ask_user(qmsg("delete", "backup"), opts):
	//	                    delete_file(bfile, True)
	//	            if act_backup:
	//	                if ask_user(qmsg("create", "original"), opts):
	//	                    copy_file(bfile, ofile)
	//	        case True, True:
	//	            if opt_toggle or file not in notdiff:
	//	                if are_files_different(ofile, bfile):
	//	                    fout(ofile, "original and backup files", "differ")
	//	                    if opt_diff:
	//	                        old = ofile if act_backup else bfile
	//	                        new = bfile if act_backup else ofile
	//	                        diff(old, new)
	//	                    if act_save:
	//	                        if ask_user(qmsg("update", "backup"), opts):
	//	                            copy_file(ofile, bfile)
	//	                    if act_backup:
	//	                        if ask_user(qmsg("update", "original"), opts):
	//	                            copy_file(bfile, ofile)

	//	def qmsg(act, on,  prefix=""):
	//	    res = prefix + "Do you really want to " + act + " " + on + " file? "
	//	    return color("msg", res)
	//
	//	def fout(file, on=None, stat=None):
	//	    msg_file = color("file", file)
	//	    if opt_verbose and on and stat:
	//	        print(msg_file + " : " + on + " " + stat)
	//	    else:
	//	        print(msg_file)

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
				var input string
				fmt.Print(utils.ColorMsg("Write commit message: ", utils.MsgInfo))
				fmt.Scanln(&input)
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
