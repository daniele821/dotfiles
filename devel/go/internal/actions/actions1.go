package actions

import (
	"autosaver/internal/utils"
	"fmt"
)

func backupAction(flag *utils.Flag) {}

func untrackedAction(flag *utils.Flag) {}

func commitAction(flag *utils.Flag) {
	optToggle := flag.HasOptionFlag(utils.OptToggle)
	optDiff := flag.HasOptionFlag(utils.OptDiff)
	autoAnswer := autoAnswer(flag)

	if !optToggle {
		utils.ProcessGitPull()
	}

	if utils.ProcessHasGitChanges() {
		if optDiff {
			utils.ProcessGitDiff(optToggle)
		}
		utils.ProcessGitStatus()
		if !optToggle {
			if utils.AskUser(utils.ColorMsg("Do you really want to commit all? ", utils.MsgInfo), autoAnswer) {
				var input string
				fmt.Print(utils.ColorMsg("Write commit message: ", utils.MsgInfo))
				fmt.Scanln(&input)
				if input != "" {
					utils.ProcessGitCommitAll("")
				}
			}
		} else {
			if utils.AskUser(utils.ColorMsg("Do you really want to restore all? ", utils.MsgInfo), autoAnswer) {
				utils.ProcessGitRestoreAll()
			}
		}
	} else if optToggle {
		utils.ProcessGitRestoreAll()
	}

	if !optToggle {
		utils.ProcessGitPush()
	}
}

// def backup_files(act, opts):
//     odir = HOME
//     bdir = DIRS["backup"]
//     act_save = act == ACTIONS.SAVE
//     act_backup = act == ACTIONS.BACKUP
//     opt_toggle = FLAGS.TOGGLE in opts
//     opt_diff = FLAGS.DIFF in opts
//     opt_force = FLAGS.FORCE in opts
//     opt_verbose = FLAGS.VERBOSE in opts
//     tracked = load_config(FILES["track"])
//     notdiff = load_config(FILES["notdiff"])
//     all = sorted(tracked | notdiff)
//
//     def qmsg(act, on,  prefix=""):
//         res = prefix + "Do you really want to " + act + " " + on + " file? "
//         return color("msg", res)
//
//     def fout(file, on=None, stat=None):
//         msg_file = color("file", file)
//         if opt_verbose and on and stat:
//             print(msg_file + " : " + on + " " + stat)
//         else:
//             print(msg_file)
//
//     for file in all:
//         ofile = os.path.join(odir, file)
//         bfile = os.path.join(bdir, file)
//         match os.path.isfile(ofile), os.path.isfile(bfile):
//             case True, False:
//                 fout(ofile, "backup file", "is missing")
//                 if act_save:
//                     if ask_user(qmsg("create", "backup"), opts):
//                         copy_file(ofile, bfile)
//                 if act_backup and opt_force:
//                     if ask_user(qmsg("delete", "original", "[DANGER] "), opts):
//                         delete_file(ofile)
//             case False, True:
//                 fout(ofile, "original file", "is missing")
//                 if act_save:
//                     if ask_user(qmsg("delete", "backup"), opts):
//                         delete_file(bfile, True)
//                 if act_backup:
//                     if ask_user(qmsg("create", "original"), opts):
//                         copy_file(bfile, ofile)
//             case True, True:
//                 if opt_toggle or file not in notdiff:
//                     if are_files_different(ofile, bfile):
//                         fout(ofile, "original and backup files", "differ")
//                         if opt_diff:
//                             old = ofile if act_backup else bfile
//                             new = bfile if act_backup else ofile
//                             diff(old, new)
//                         if act_save:
//                             if ask_user(qmsg("update", "backup"), opts):
//                                 copy_file(ofile, bfile)
//                         if act_backup:
//                             if ask_user(qmsg("update", "original"), opts):
//                                 copy_file(bfile, ofile)
//
//
// def untracked_files(opts):
//     tracked = load_config(FILES["track"]) | load_config(FILES["notdiff"])
//     backup = set(all_files(DIRS["backup"], DIRS["backup"]))
//     opt_toggle = FLAGS.TOGGLE in opts
//     opt_force = FLAGS.FORCE in opts
//     bmsg = "Do you really want to delete backup file ? "
//     bmsg = color("msg", bmsg)
//     omsg = "[DANGER] Do you really want to delete original file ? "
//     omsg = color("msg", omsg)
//     for file in sorted(backup - tracked):
//         ofile = os.path.join(HOME, file)
//         bfile = os.path.join(DIRS["backup"], file)
//         print(color("file", ofile))
//         if opt_toggle:
//             if ask_user(bmsg, opts):
//                 delete_file(bfile, True)
//             if opt_force and os.path.isfile(ofile):
//                 if ask_user(omsg, opts):
//                     delete_file(ofile)
