package utils

import (
	"fmt"
	"slices"
	"strings"
)

type Flag struct {
	actionFlags []Action
	optionFlags []Option
}

func NewFlags(actions []Action, options []Option) *Flag {
	return &Flag{actions, options}
}

func (f *Flag) AppendFlags(actions []Action, options []Option) {
	f.actionFlags = append(f.actionFlags, actions...)
	f.optionFlags = append(f.optionFlags, options...)
}

func (f *Flag) AppendAllFlags(flags *Flag) {
	f.AppendFlags(flags.actionFlags, flags.optionFlags)
}

func (f *Flag) HasOptionFlag(option Option) bool {
	return slices.Contains(f.optionFlags, option)
}

func (f *Flag) GetActionFlag() Action {
	f.actionFlags = slices.Compact(f.actionFlags)
	if len(f.actionFlags) >= 2 {
		ErrExit("multiple actions are not supported")
	}
	if len(f.actionFlags) == 1 {
		return f.actionFlags[0]
	}
	return ActDefault
}

func (f *Flag) String() string {
	builder := strings.Builder{}
	builder.WriteString("Actions:")
	for act := range f.actionFlags {
		builder.WriteString(fmt.Sprintf(" %T", Action(act)))
	}
	builder.WriteString(", Options: ")
	for opt := range f.optionFlags {
		builder.WriteString(fmt.Sprintf(" %T", Option(opt)))
	}
	return builder.String()
}
