package utils

import (
	"fmt"
	"slices"
	"strings"
)

type flag struct {
	actionFlags []action
	optionFlags []option
}

func NewFlags(actions []action, options []option) *flag {
	return &flag{actions, options}
}

func (f *flag) AppendFlags(actions []action, options []option) {
	f.actionFlags = append(f.actionFlags, actions...)
	f.optionFlags = append(f.optionFlags, options...)
}

func (f *flag) AppendAllFlags(flags *flag) {
	f.AppendFlags(f.actionFlags, f.optionFlags)
}

func (f *flag) HasFlag(flag any) bool {
	switch flag.(type) {
	case action:
		action, _ := flag.(action)
		return slices.Contains(f.actionFlags, action)
	case option:
		option, _ := flag.(option)
		return slices.Contains(f.optionFlags, option)
	}
	return false
}

func (f *flag) String() string {
	builder := strings.Builder{}
	builder.WriteString("Actions:")
	for act := range f.actionFlags {
		builder.WriteString(fmt.Sprintf(" %T", action(act)))
	}
	builder.WriteString(", Options: ")
	for opt := range f.optionFlags {
		builder.WriteString(fmt.Sprintf(" %T", option(opt)))
	}
	return builder.String()
}
