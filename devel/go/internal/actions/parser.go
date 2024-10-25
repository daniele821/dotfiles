package actions

import (
	"autosaver/internal/utils"
	"os"
)

func loadConf(configFile string) []string {
	fileList := []string{}
	if utils.IsRegularFile(configFile) {
		file, err := os.Open(configFile)
		if err != nil {
			utils.ErrExit("could not open file")
		}
		defer file.Close()
	}
	// odir = HOME
	// bdir = DIRS["backup"]
	// files = set()
	// if os.path.isfile(conf):
	//     for line in read_file(conf).splitlines():
	//         if not line.startswith("/") and line:
	//             ofile = os.path.join(odir, line)
	//             bfile = os.path.join(bdir, line)
	//             for file, dir in ((ofile, odir), (bfile, bdir)):
	//                 if os.path.isfile(file):
	//                     files.add(line)
	//                 elif os.path.isdir(file):
	//                     files.update(all_files(file, dir))
	// return files

	return fileList
}

func ParseArgs(args []string) *utils.Flag {
	return nil
}
