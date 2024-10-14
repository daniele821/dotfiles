package utils

import (
	"fmt"
	"strings"
)

type MsgType int8
type Answer string

const (
	MsgErr MsgType = iota
	MsgFile
	MsgInfo
	MsgNone
)
const (
	Yes  Answer = "y"
	No   Answer = "n"
	None        = ""
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
	case Yes, No:
		fmt.Println(autoAnswer)
		return autoAnswer == Yes
	case None:
		var input string
		fmt.Scanln(&input)
		switch input {
		case string(Yes), string(No), string(None):
			return msg == string(Yes)
		default:
			fmt.Println("Invalid answer, retry:")
			return AskUser(msg, autoAnswer)
		}
	}
	return false
}
