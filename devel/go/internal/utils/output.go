package utils

import (
	"fmt"
	"os"
	"strings"
)

type MsgType int8
type Answer string

const (
	MsgNone MsgType = iota
	MsgErr
	MsgFile
	MsgInfo
)
const (
	AnsNone Answer = ""
	AnsYes  Answer = "y"
	AnsNo   Answer = "n"
)

func ColorMsg(str string, col MsgType) string {
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
	case AnsYes, AnsNo:
		fmt.Println(autoAnswer)
		return autoAnswer == AnsYes
	case AnsNone:
		var input string
		fmt.Scanln(&input)
		{
			input := Answer(input)
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

func errExit(msg string) {
	os.Stderr.WriteString(ColorMsg("ERROR: ", MsgErr))
	os.Stderr.WriteString(ColorMsg(msg, MsgErr))
	os.Stderr.WriteString("\n")
	os.Exit(1)
}
