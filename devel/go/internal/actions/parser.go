package actions

import (
	"autosaver/internal/utils"
	"bufio"
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

func ParseArgs(args []string) *utils.Flag {
	var flag *utils.Flag
	return flag
}
