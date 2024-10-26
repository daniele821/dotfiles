package main

import (
	"autosaver/internal/actions"
	"fmt"
	"os"
)

func version(args string) {
	if args == "--version" {
		fmt.Println("the current version is 3.0.0 (2024-10-26 11:30)")
		os.Exit(0)
	}
}

func main() {
	args := os.Args[1:]

	version(args[0])

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
