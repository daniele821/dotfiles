package main

import (
	"autosaver/internal/actions"
	"fmt"
	"os"
)

func version(args string) {
	if args == "--version" {
		fmt.Println("the current version is 3.0.2 (2024-10-26 12:45)")
		os.Exit(0)
	}
}

func main() {
	args := os.Args[1:]

	if len(args) >= 1 {
		version(args[0])
	}

	params := []string{}
	for _, arg := range args {
		if arg == "--" {
			flags := actions.ParseArgs(params)
			actions.Execute(flags)
			params = nil
		} else {
			params = append(params, arg)
		}
	}
	flags := actions.ParseArgs(params)
	actions.Execute(flags)
}
