package utils

import (
	"fmt"
	"os"
	"strings"
)

type msgType int8
type answer string

const (
	MsgNone msgType = iota
	MsgErr
	MsgFile
	MsgInfo
)
const (
	AnsNone answer = ""
	AnsYes  answer = "y"
	AnsNo   answer = "n"
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

func AskUser(msg string, autoAnswer answer) bool {
	fmt.Print(msg)
	switch autoAnswer {
	case AnsYes, AnsNo:
		fmt.Println(autoAnswer)
		return autoAnswer == AnsYes
	case AnsNone:
		var input string
		fmt.Scanln(&input)
		{
			input := answer(input)
			switch input {
			case AnsYes, AnsNo, AnsNone:
				return input == AnsYes
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
