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
	var defAct utils.Action
	var defOpt utils.Option
	flag := &utils.Flag{}
	for _, word := range args {
		if strings.HasPrefix(word, "-") {
			for _, letter := range word[1:] {
				char := string(letter)
				act := utils.ParseAction[char]
				opt := utils.ParseOption[char]
				if act != defAct || opt != defOpt {
					acts := []utils.Action{}
					opts := []utils.Option{}
					if act != defAct {
						acts = append(acts, act)
					}
					if opt != defOpt {
						opts = append(opts, opt)
					}
					flag.AppendFlags(acts, opts)
				} else {
					utils.ErrExit("invalid flag: \"%s\"", char)
				}
			}
		} else {
			shortcut := utils.ParseShortcut[word]
			if shortcut != nil {
				flag.AppendAllFlags(shortcut)
			} else {
				utils.ErrExit("invalid shortcut value: \"%s\"", word)
			}
		}
	}
	return flag
}
