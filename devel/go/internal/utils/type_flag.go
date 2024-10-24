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

func (f *Flag) HasFlag(flag any) bool {
	switch flag.(type) {
	case Action:
		action, _ := flag.(Action)
		return slices.Contains(f.actionFlags, action)
	case Option:
		option, _ := flag.(Option)
		return slices.Contains(f.optionFlags, option)
	}
	return false
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
