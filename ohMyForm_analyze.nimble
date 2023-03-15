# Package

version       = "1.1.0"
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
  let
    f = binDir / bin[0] & "." & backend
    outF = binDir / bin[0] & ".user." & backend
  exec fmt"uglifyjs -o {f} {f}"
  let cssCode = gorgeEx("sass src/style/ohMyForm_analyze.sass")
  if cssCode.exitCode != 0:
    quit cssCode.output
  outF.writeFile (userscriptHeader & "\n" & f.readFile).replace("CSSCODEHERE", cssCode.output.encode)
  rmFile f

task buildRelease, "Build release version":
  exec "nimble -d:danger build"
  finalizeTask()
