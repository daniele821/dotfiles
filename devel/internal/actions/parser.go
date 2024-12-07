package actions

import (
	"autosaver/internal/configs"
	"autosaver/internal/utils"
	"bufio"
	"os"
	"path/filepath"
	"slices"
	"strings"
)

func loadConf(configFile string, fileType utils.FileType) []string {
	home := configs.Home
	backup := configs.AllDirs[configs.DirBackup]
	fileList := []string{}
	if utils.FileTypeFileRegular.Check(configFile) {

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
				fileList = append(fileList, utils.AllFilesInDir(homeFile, home, fileType)...)
				fileList = append(fileList, utils.AllFilesInDir(backupFile, backup, fileType)...)
			}
		}
	}
	slices.Sort(fileList)
	return slices.Compact(fileList)
}

func ParseArgs(args []string) configs.Flag {
	flag := configs.Flag{}
	for _, word := range args {
		if strings.HasPrefix(word, "-") {
			for _, letter := range word[1:] {
				char := string(letter)
				act, okAct := configs.ParseAction[char]
				opt, okOpt := configs.ParseOption[char]
				if okAct || okOpt {
					acts := []configs.Action{}
					opts := []configs.Option{}
					if okAct {
						acts = append(acts, act)
					}
					if okOpt {
						opts = append(opts, opt)
					}
					flag.AppendFlags(acts, opts)
				} else {
					utils.ErrExit("invalid flag: \"%s\"", char)
				}
			}
		} else {
			shortcut := configs.ParseShortcut[word]
			if !shortcut.IsEmpty() {
				flag.AppendAllFlags(shortcut)
			} else {
				utils.ErrExit("invalid shortcut value: \"%s\"", word)
			}
		}
	}
	return flag
}
