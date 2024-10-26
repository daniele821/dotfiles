package utils

import (
	"fmt"
	"os"
	"strings"
)

type msgType int
type Answer int

const (
	MsgNone msgType = iota
	MsgErr
	MsgFile
	MsgInfo
)
const (
	AnsNone Answer = iota
	AnsYes
	AnsNo
)

func ColorMsg(str string, col msgType) string {
	res := strings.Builder{}
	switch col {
	case MsgErr:
		res.WriteString("\x1b[1;31m")
	case MsgFile:
		res.WriteString("\x1b[1;34m")
	case MsgInfo:
		res.WriteString("\x1b[1;33m")
	}
	res.WriteString(str)
	res.WriteString("\x1b[m")
	return res.String()
}

func AskUser(msg string, autoAnswer Answer) bool {
	fmt.Print(msg)
	switch autoAnswer {
	case AnsYes:
		fmt.Println("y")
		return true
	case AnsNo:
		fmt.Println("n")
		return false
	case AnsNone:
		var input string
		fmt.Scanln(&input)
		{
			switch input {
			case "y", "n", "":
				return input == "y"
			default:
				fmt.Println("Invalid answer, retry:")
				return AskUser(msg, autoAnswer)
			}
		}
	}
	return false
}

func ErrExit(msg string, a ...any) {
	msg = fmt.Sprintf(msg, a...)
	os.Stderr.WriteString(ColorMsg("ERROR: ", MsgErr))
	os.Stderr.WriteString(ColorMsg(msg, MsgErr))
	os.Stderr.WriteString("\n")
	os.Exit(1)
}
