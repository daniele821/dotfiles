package actions

import (
	"autosaver/internal/utils"
	"bufio"
	"errors"
	"os"
	"path/filepath"
	"slices"
	"strings"
)

func loadConf(configFile string) []string {
	home := utils.Home
	backup := utils.AllDirs[utils.DirBackup]
	fileList := []string{}
	if utils.IsRegularFile(configFile) {

		file, err := os.Open(configFile)
		if err != nil {
			utils.ErrExit("could not open file \"%s\"", configFile)
		}
		defer file.Close()

		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			line := scanner.Text()
			if !strings.HasPrefix(line, "/") && line != "" {
				homeFile := filepath.Join(home, line)
				backupFile := filepath.Join(backup, line)
				fileList = append(fileList, utils.AllFilesInDir(homeFile, home)...)
				fileList = append(fileList, utils.AllFilesInDir(backupFile, backup)...)
			}
		}
	}
	slices.Sort(fileList)
	return slices.Compact(fileList)
}

func parseShortcut(shortcut string) (utils.Shortcut, error) {
	switch shortcut {
	case "save":
		return utils.ShortcutSave, nil
	case "saveall":
		return utils.ShortcutSaveAll, nil
	case "restore":
		return utils.ShortcutRestore, nil
	case "restoreall":
		return utils.ShortcutRestoreAll, nil
	case "commit", "co":
		return utils.ShortcutCommit, nil
	case "uncommit", "un":
		return utils.ShortcutUncommit, nil
	case "untracked":
		return utils.ShortcutUntracked, nil
	case "init":
		return utils.ShortcutInit, nil
	case "run":
		return utils.ShortcutRun, nil
	case "edit":
		return utils.ShortcutEdit, nil
	}
	return utils.Shortcut(0), errors.New("not a valid shortcut")
}

func ParseArgs(args []string) *utils.Flag {
	return nil
}
