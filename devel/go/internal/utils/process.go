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
	run("diff", "--no-dereference", "--color", "-u", file1, file2)
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

func ProcessGitPull(gitRootDir string) {
	run("git", "-C", gitRootDir, "pull")
}

func ProcessGitPush(gitRootDir string) {
	run("git", "-C", gitRootDir, "push")
}

func ProcessGitStatus(gitRootDir string) {
	run("git", "-C", gitRootDir, "status", "-su")
}

func ProcessGitDiff(gitRootDir string, reverse bool) {
	if !reverse {
		run("git", "-C", gitRootDir, "diff", "HEAD", "--diff-filter=adcr")
	} else {
		run("git", "-C", gitRootDir, "diff", "HEAD", "--diff-filter=adcr", "-R")
	}
}

func ProcessGitRestoreAll(gitRootDir string) {
	run("git", "-C", gitRootDir, "reset", "HEAD")
	run("git", "-C", gitRootDir, "restore", "--staged", gitRootDir)
	run("git", "-C", gitRootDir, "restore", gitRootDir)
	run("git", "-C", gitRootDir, "clean", "-fdq")
}

func ProcessGitCommitAll(gitRootDir string, commitMsg string) {
	run("git", "-C", gitRootDir, "add", gitRootDir)
	run("git", "-C", gitRootDir, "commit", "-m", commitMsg)
}

func ProcessHasGitChanges(gitRootDir string) bool {
	cmd := exec.Command("git", "-C", gitRootDir, "status", "-s")
	output, _ := cmd.Output()
	return strings.TrimSpace(string(output)) != ""
}

func ProcessGitRootDir(scriptDir string) string {
	cmd := exec.Command("git", "-C", scriptDir, "rev-parse", "--show-toplevel")
	output, err := cmd.Output()
	if err != nil {
		ErrExit("the autosaver executable is not in a git repository!")
	}
	return strings.TrimSpace(string(output))
}
