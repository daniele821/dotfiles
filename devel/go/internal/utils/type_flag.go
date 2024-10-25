package utils

import (
	"fmt"
	"slices"
	"strings"
)

type Flag struct {
	actionFlags []action
	optionFlags []option
}

func NewFlags(actions []action, options []option) *Flag {
	return &Flag{actions, options}
}

func (f *Flag) AppendFlags(actions []action, options []option) {
	f.actionFlags = append(f.actionFlags, actions...)
	f.optionFlags = append(f.optionFlags, options...)
}

func (f *Flag) AppendAllFlags(flags *Flag) {
	f.AppendFlags(flags.actionFlags, flags.optionFlags)
}

func (f *Flag) HasOptionFlag(option option) bool {
	return slices.Contains(f.optionFlags, option)
}

func (f *Flag) GetActionFlag() action {
	f.actionFlags = slices.Compact(f.actionFlags)
	if len(f.actionFlags) >= 2 {
		ErrExit("multiple actions are not supported")
	}
	if len(f.actionFlags) == 1 {
		return f.actionFlags[0]
	}
	return ActNone
}

func (f *Flag) String() string {
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
