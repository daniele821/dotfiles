package utils

import "fmt"

func (msgType msgType) String() string {
	switch msgType {
	case MsgErr:
		return "MsgErr"
	case MsgFile:
		return "MsgFile"
	case MsgInfo:
		return "MsgInfo"
	}
	return fmt.Sprintf("msgType(%d)", msgType)
}

func (answer Answer) String() string {
	switch answer {
	case AnsYes:
		return "AnsYes"
	case AnsNo:
		return "AnsNo"
	}
	return fmt.Sprintf("Answer(%d)", answer)
}

func (fileType FileType) String() string {
	switch fileType {
	case FileTypeExist:
		return "FileTypeExist"
	case FileTypeFile:
		return "FileTypeFile"
	case FileTypeDir:
		return "FileTypeDir"
	case FileTypeFileRegular:
		return "FileTypeFileRegular"
	case FileTypeFileSymlink:
		return "FileTypeFileSymlink"
	case FileTypeNotExist:
		return "FileTypeNotExist"
	}
	return fmt.Sprintf("FileType(%d)", fileType)
}
