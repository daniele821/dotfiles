package utils

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type msgType int
type Answer int

const (
	MsgErr msgType = iota
	MsgFile
	MsgInfo
)
const (
	AnsYes Answer = iota
	AnsNo
)

func ColorMsg(str string, col ...msgType) string {
	res := strings.Builder{}
	if len(col) > 1 {
		panic("multiple values of the variadic arg are not accepted!")
	}
	if len(col) != 0 {
		switch col[0] {
		case MsgErr:
			res.WriteString("\x1b[1;31m")
		case MsgFile:
			res.WriteString("\x1b[1;34m")
		case MsgInfo:
			res.WriteString("\x1b[1;33m")
		}
	}
	res.WriteString(str)
	res.WriteString("\x1b[m")
	return res.String()
}

func ReadInput() string {
	reader := bufio.NewScanner(os.Stdin)
	if reader.Scan() {
		return reader.Text()
	}
	return ""
}

func AskUser(msg string, autoAnswer ...Answer) bool {
	fmt.Print(msg)
	if len(autoAnswer) > 1 {
		panic("multiple values of the variadic arg are not accepted!")
	}
	if len(autoAnswer) != 0 {
		input := ReadInput()
		{
			switch input {
			case "y", "n", "":
				return input == "y"
			default:
				fmt.Println("Invalid answer, retry:")
				return AskUser(msg, autoAnswer...)
			}
		}
	}
	switch autoAnswer[0] {
	case AnsYes:
		fmt.Println("y")
		return true
	case AnsNo:
		fmt.Println("n")
		return false
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
