package main

import (
	"autosaver/internal/actions"
	"autosaver/internal/configs"
	"fmt"
	"os"
	"time"
)

func dbgOutput(output ...string) {
	if !configs.EnvPerf {
		return
	}
	for _, msg := range output {
		fmt.Fprint(os.Stderr, "\x1b[1m", msg, "\x1b[m")
	}
}

func runPerf(msg string, run func()) {
	start := time.Now()
	run()
	perf := time.Since(start)
	dbgOutput(msg, perf.String(), "\n")
}

func main() {
	args := os.Args[1:]

	params := []string{}
	for _, arg := range append(args, "--") {
		if arg == "--" {
			var flags configs.Flag
			dbgOutput()
			runPerf("Parsing flags   -->   ", func() { flags = actions.ParseArgs(params) })
			dbgOutput(flags.String(), "\n")
			runPerf("Executing       -->   ", func() { actions.Execute(flags) })
			dbgOutput("\n")
			params = nil
		} else {
			params = append(params, arg)
		}
	}
}
