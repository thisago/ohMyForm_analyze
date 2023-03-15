# Package

version       = "0.1.0"
author        = "Thiago Navarro"
description   = "A userscript that creates a easy to use interface to analyze the submitted forms"
license       = "MIT"
srcDir        = "src"
bin           = @["ohMyForm_analyze"]
binDir = "build"

backend = "js"

# Dependencies

requires "nim >= 1.6.4"

requires "karax"

requires "util"
requires "gm_api"
requires "jsFetchMock"

import src/ohMyForm_analyze/header

from std/strformat import fmt
from std/strutils import replace
from std/base64 import encode
from std/os import `/`

task finalize, "Uglify and add header":
  let f = binDir / bin[0] & "." & backend
  exec fmt"uglifyjs -o {f} {f}"
  let cssCode = gorgeEx("sass src/style/ohMyForm_analyze.sass")
  if csscode.exitCode != 0:
    quit cssCode.output
  f.writeFile (userscriptHeader & "\n" & f.readFile).replace("CSSCODEHERE", cssCode.output.encode)

task buildRelease, "Build release version":
  exec "nimble -d:danger build"
  finalizeTask()
