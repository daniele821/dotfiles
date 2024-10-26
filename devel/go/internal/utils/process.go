package utils

import (
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
