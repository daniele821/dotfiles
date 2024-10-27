package configs

import (
	"autosaver/internal/utils"
	"slices"
)

type Flag struct {
	actionFlags []Action
	optionFlags []Option
}

func NewFlags(actions []Action, options []Option) Flag {
	return Flag{actions, options}
}

func (f Flag) AppendFlags(actions []Action, options []Option) {
	f.actionFlags = append(f.actionFlags, actions...)
	f.optionFlags = append(f.optionFlags, options...)
}

func (f Flag) AppendAllFlags(flags Flag) {
	f.AppendFlags(flags.actionFlags, flags.optionFlags)
}

func (f Flag) HasOptionFlag(option Option) bool {
	return slices.Contains(f.optionFlags, option)
}

func (f Flag) GetActionFlag() Action {
	if len(f.actionFlags) >= 2 {
		utils.ErrExit("multiple actions are not supported")
	}
	if len(f.actionFlags) == 1 {
		return f.actionFlags[0]
	}
	return ActDefault
}

func (f Flag) IsEmpty() bool {
	return len(f.actionFlags) == 0 && len(f.optionFlags) == 0
}
