package utils

import (
	"io/fs"
	"os"
	"path/filepath"
)

func IsRegularFile(path string) bool {
	info, err := os.Lstat(path)
	if err != nil {
		return false
	}
	return info.Mode().IsRegular()
}

func IsDirectory(path string) bool {
	info, err := os.Lstat(path)
	if err != nil {
		return false
	}
	return info.IsDir()
}

func CreateDir(dirPath string) {
	if os.MkdirAll(dirPath, 0777) != nil {
		ErrExit("could not create directory: \"%s\"", dirPath)
	}
}

func CreateFile(filePath string) {
	CreateDir(filepath.Dir(filePath))
	_, err := os.Create(filePath)
	if err != nil {
		ErrExit("could not create file: \"%s\"", filePath)
	}
}

func DeleteFile(filePath string, deleteDirs bool) {
	os.Remove(filePath)
	dir := filePath
	if deleteDirs {
		for {
			dir = filepath.Dir(dir)
			if os.Remove(dir) != nil {
				break
			}
		}
	}
}

func readFile(filePath string) []byte {
	bytes, err := os.ReadFile(filePath)
	if err != nil {
		ErrExit("could not read file: \"%s\"", filePath)
	}
	return bytes
}

func ReadFile(filePath string) string {
	return string(readFile(filePath))
}

func CopyFile(src, dst string) {
	CreateFile(dst)
	if os.WriteFile(dst, readFile(src), 0644) != nil {
		DeleteFile(dst, false)
		ErrExit("could not write to file: \"%s\"", dst)
	}
}

func AllFilesInDir(dir, relPath string) []string {
	var files []string
	visit := func(path string, dirEntry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if dirEntry.Type().IsRegular() {
			if relPath != "" {
				path, err = filepath.Rel(relPath, path)
				if err != nil {
					return err
				}
			}
			files = append(files, path)
		}
		return nil
	}
	err := filepath.WalkDir(dir, visit)
	if err != nil {
		return []string{}
	}
	return files
}
