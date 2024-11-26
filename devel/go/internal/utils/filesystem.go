package utils

import (
	"bytes"
	"io"
	"io/fs"
	"os"
	"path/filepath"
)

type FileType int64

const (
	FileTypeNotExist FileType = 1 << iota
	FileTypeExist
	FileTypeFile = 1<<iota | FileTypeExist
	FileTypeDir
	FileTypeFileRegular = 1<<iota | FileTypeFile
	FileTypeFileSymlink
)

func GetFileType(path string) FileType {
	fileType := FileTypeNotExist
	info, err := os.Lstat(path)
	if err != nil {
		return fileType
	} else {
		fileType |= FileTypeExist
	}
	if info.IsDir() {
		fileType |= FileTypeDir
	} else if info.Mode().IsRegular() {
		fileType |= FileTypeFileRegular
	} else if info.Mode()&os.ModeSymlink == os.ModeSymlink {
		fileType |= FileTypeFileSymlink
	}
	return fileType
}

func (fileType FileType) Check(path string) bool {
	return GetFileType(path)&fileType == fileType
}

func CreateDir(dirPath string) {
	if os.MkdirAll(dirPath, 0777) != nil {
		ErrExit("could not create directory: \"%s\"", dirPath)
	}
}

func CreateFile(filePath string) {
	if FileTypeExist.Check(filePath) {
		return
	}
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

func DeleteDir(dirPath string, recursiveDelete bool) {
	if recursiveDelete {
		os.RemoveAll(dirPath)
	} else {
		os.Remove(dirPath)
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
	if !FileTypeFile.Check(src) {
		ErrExit("path not a file: \"%s\"", src)
	}
	CreateDir(filepath.Dir(dst))
	if FileTypeFileRegular.Check(src) {
		if os.WriteFile(dst, readFile(src), 0644) != nil {
			DeleteFile(dst, false)
			ErrExit("could not write to file: \"%s\"", dst)
		}
	} else if FileTypeFileSymlink.Check(src) {
		pointed, err := os.Readlink(src)
		if err != nil {
			ErrExit("could not read file: \"%s\"", src)
		}
		os.Symlink(pointed, dst)
	}
}

func AllFilesInDir(dir, relPath string) []string {
	var files []string
	visit := func(path string, dirEntry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if FileTypeFile.Check(path) {
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

func FilesDiffer(file1, file2 string) bool {
	const chunkSize int = 64000
	// shortcuts: check file metadata
	stat1, err := os.Stat(file1)
	if err != nil {
		return true
	}
	stat2, err := os.Stat(file2)
	if err != nil {
		return true
	}
	// are inputs are literally the same file?
	if os.SameFile(stat1, stat2) {
		return false
	}
	// do inputs at least have the same size?
	if stat1.Size() != stat2.Size() {
		return true
	}
	// check if files types differs
	if GetFileType(file1) != GetFileType(file2) {
		return true
	}
	// compare two symlinks
	if FileTypeFileSymlink.Check(file1) && FileTypeFileSymlink.Check(file2) {
		lnk1, _ := os.Readlink(file1)
		lnk2, _ := os.Readlink(file2)
		return lnk1 != lnk2
	}
	// long way: compare contents
	f1, err := os.Open(file1)
	if err != nil {
		return true
	}
	defer f1.Close()
	f2, err := os.Open(file2)
	if err != nil {
		return true
	}
	defer f2.Close()
	b1 := make([]byte, chunkSize)
	b2 := make([]byte, chunkSize)
	for {
		n1, err1 := io.ReadFull(f1, b1)
		n2, err2 := io.ReadFull(f2, b2)
		// https://pkg.go.dev/io#Reader
		// > Callers should always process the n > 0 bytes returned
		// > before considering the error err. Doing so correctly
		// > handles I/O errors that happen after reading some bytes
		// > and also both of the allowed EOF behaviors.
		if !bytes.Equal(b1[:n1], b2[:n2]) {
			return true
		}
		if (err1 == io.EOF && err2 == io.EOF) || (err1 == io.ErrUnexpectedEOF && err2 == io.ErrUnexpectedEOF) {
			return false
		}
		// some other error, like a dropped network connection or a bad transfer
		if err1 != nil {
			return true
		}
		if err2 != nil {
			return true
		}
	}
}
