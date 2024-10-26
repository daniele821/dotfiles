package utils

import (
	"bytes"
	"io"
	"os"
	"os/exec"
	"strings"
)

func redirect(cmd *exec.Cmd) {
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
}

func run(cmd ...string) bool {
	command := exec.Command(cmd[0], cmd[1:]...)
	redirect(command)
	return command.Run() == nil
}

func checkIfExecInPath(executable string) bool {
	_, err := exec.LookPath(executable)
	return err == nil
}

func ProcessDiff(file1, file2 string) {
	run("diff", "--color", "-u", file1, file2)
}

func filesDiffer(file1, file2 string) bool {
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

func ProcessFilesDiffer(file1, file2 string) bool {
	// return exec.Command("diff", "-q", file1, file2).Run() != nil
	return filesDiffer(file1, file2)
}

func ProcessEdit(file string) {
	switch {
	case checkIfExecInPath("nvim"):
		run("nvim", file)
	case checkIfExecInPath("vim"):
		run("vim", file)
	case checkIfExecInPath("nano"):
		run("nano", file)
	}
}

func ProcessExecute(file string) bool {
	return run(file)
}

func ProcessGitPull(scriptDir string) {
	run("git", "-C", scriptDir, "pull")
}

func ProcessGitPush(scriptDir string) {
	run("git", "-C", scriptDir, "push")
}

func ProcessGitStatus(scriptDir string) {
	run("git", "-C", scriptDir, "status", "-su")
}

func ProcessGitDiff(scriptDir string, reverse bool) {
	if reverse {
		run("git", "-C", scriptDir, "diff", "HEAD", "--diff-filter=adcr")
	} else {
		run("git", "-C", scriptDir, "diff", "HEAD", "--diff-filter=adcr", "-R")
	}
}

func ProcessGitRestoreAll(scriptDir string) {
	run("git", "-C", scriptDir, "reset", "HEAD")
	run("git", "-C", scriptDir, "restore", "--staged", scriptDir)
	run("git", "-C", scriptDir, "restore", scriptDir)
	run("git", "-C", scriptDir, "clean", "-fdq")
}

func ProcessGitCommitAll(scriptDir string, commitMsg string) {
	run("git", "-C", scriptDir, "add", scriptDir)
	run("git", "-C", scriptDir, "commit", "-m", commitMsg)
}

func ProcessHasGitChanges(scriptDir string) bool {
	cmd := exec.Command("git", "-C", scriptDir, "status", "-s")
	output, _ := cmd.Output()
	return strings.TrimSpace(string(output)) != ""
}
