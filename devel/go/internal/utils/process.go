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

func ProcessFilesDiffer(file1, file2 string) bool {
	return exec.Command("diff", "-q", file1, file2).Run() != nil
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

func ProcessGitPull() {
	run("git", "-C", ScriptDir, "pull")
}

func ProcessGitPush() {
	run("git", "-C", ScriptDir, "push")
}

func ProcessGitStatus() {
	run("git", "-C", ScriptDir, "status", "-su")
}

func ProcessGitDiff(reverse bool) {
	if reverse {
		run("git", "-C", ScriptDir, "diff", "HEAD", "--diff-filter=adcr")
	} else {
		run("git", "-C", ScriptDir, "diff", "HEAD", "--diff-filter=adcr", "-R")
	}
}

func ProcessGitRestoreAll() {
	run("git", "-C", ScriptDir, "reset", "HEAD")
	run("git", "-C", ScriptDir, "restore", "--staged", ScriptDir)
	run("git", "-C", ScriptDir, "restore", ScriptDir)
	run("git", "-C", ScriptDir, "clean", "-fdq")
}

func ProcessGitCommitAll(commitMsg string) {
	run("git", "-C", ScriptDir, "add", ScriptDir)
	run("git", "-C", ScriptDir, "commit", "-m", commitMsg)
}

func ProcessHasGitChanges() bool {
	cmd := exec.Command("git", "-C", ScriptDir, "status", "-s")
	output, _ := cmd.Output()
	return strings.TrimSpace(string(output)) != ""
}
