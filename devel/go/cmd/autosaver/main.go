package main

import (
	"autosaver/internal/actions"
	"os"
)

func main() {
	args := os.Args[1:]

	params := []string{}
	for _, arg := range append(args, "--") {
		if arg == "--" {
			flags := actions.ParseArgs(params)
			actions.Execute(flags)
			params = nil
		} else {
			params = append(params, arg)
		}
	}
}
