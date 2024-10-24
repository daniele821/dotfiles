package utils

import (
	"fmt"
	"os"
	"path/filepath"
)

func CreateDir(dir_path string) {
	if os.MkdirAll(dir_path, 0777) != nil {
		errExit(fmt.Sprintf("could not create directory: \"%s\"", dir_path))
	}
}

func CreateFile(file_path string) {
	CreateDir(filepath.Dir(file_path))
	_, err := os.Create(file_path)
	if err != nil {
		errExit(fmt.Sprintf("could not create file: \"%s\"", file_path))
	}
}

func DeleteFile(file_path string, delete_dirs bool) {
	os.Remove(file_path)
	dir := file_path
	if delete_dirs {
		for {
			dir = filepath.Dir(dir)
			if os.Remove(dir) != nil {
				break
			}
		}
	}
}

func readFile(file_path string) []byte {
	bytes, err := os.ReadFile(file_path)
	if err != nil {
		errExit(fmt.Sprintf("could not read file: \"%s\"", file_path))
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
		errExit(fmt.Sprintf("could not write to file: \"%s\"", dst))
	}
}
