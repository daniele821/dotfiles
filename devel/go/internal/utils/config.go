package utils

// find way to have readonly config vars
type Config struct {
	home       string
	scriptPath string
	scriptDir  string
	dirs       []string
	files      []string
}

type Action int
type Flag int

const (
	ActNone Action = iota
	ActList
	ActUntracked
	ActSave
	ActBackup
	ActCommit
	ActEdit
	ActInit
	ActRun
)
const (
	FlagNone Flag = iota
	FlagDiff
	FlagForce
	FlagNo
	FlagYes
	FlagToggle
	FlagVerbose
)

// HOME = os.getenv("HOME")
// SCRIPT_PATH = os.path.realpath(__file__)
// SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
// DIRS = {"backup": os.path.join(SCRIPT_DIR, "backup"),
//         "config": os.path.join(SCRIPT_DIR, "config"),
//         "run": os.path.join(SCRIPT_DIR, "run"),
//         "others": os.path.join(SCRIPT_DIR, "others")}
// FILES = {"track": os.path.join(DIRS["config"], "files_to_track.txt"),
//          "notdiff": os.path.join(DIRS["config"], "files_to_notdiff.txt")}
//
//
// ACTIONS = Enum("ACTIONS", [
//     "LIST", "UNTRACKED", "SAVE", "BACKUP", "COMMIT", "EDIT", "INIT", "RUN"
// ])
// FLAGS = Enum("FLAGS", [
//     "DIFF", "FORCE", "NO", "YES", "TOGGLE", "VERBOSE"
// ])
// ACTION_FLAGS = {
//     "b": ACTIONS.BACKUP,
//     "c": ACTIONS.COMMIT,
//     "e": ACTIONS.EDIT,
//     "i": ACTIONS.INIT,
//     "r": ACTIONS.RUN,
//     "s": ACTIONS.SAVE,
//     "u": ACTIONS.UNTRACKED,
// }
// OPTION_FLAGS = {
//     "d": FLAGS.DIFF,
//     "f": FLAGS.FORCE,
//     "n": FLAGS.NO,
//     "t": FLAGS.TOGGLE,
//     "v": FLAGS.VERBOSE,
//     "y": FLAGS.YES,
// }
// ALL_FLAGS = ACTION_FLAGS | OPTION_FLAGS
// DEFAULT_ACTION = ACTIONS.LIST
// SHORTCUTS = {
//     "save": [["-svy"]],
//     "restore": [["-bvy"]],
//     "saveall": [["-svyt"]],
//     "restoreall": [["-bvyt"]],
//     "commit": [["-cy"]],
//     "uncommit": [["-cty"]],
//     "untracked": [["-u"]],
//     "init": [["-iy"]],
//     "run": [["-ry"]],
//     "edit": [["-e"]],
// }
// SHORTCUTS |= {"co": [SHORTCUTS["commit"][0]]}
// SHORTCUTS |= {"un": [SHORTCUTS["uncommit"][0]]}
// SHORTCUTS |= {"sc": [SHORTCUTS["save"][0], SHORTCUTS["commit"][0]]}
