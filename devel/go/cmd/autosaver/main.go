package main

import (
	"autosaver/internal/actions"
	"os"
)

func main() {
	args := os.Args[1:]
	flags := actions.ParseArgs(args)
	actions.Execute(flags)
}
