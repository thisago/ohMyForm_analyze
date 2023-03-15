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

requires "gm_api"
requires "jsFetchMock"

import src/core/header

from std/strformat import fmt
from std/os import `/`

task buildRelease, "Build release version":
  exec "nimble -d:danger build"
  let f = binDir / bin[0] & "." & backend
  exec fmt"uglifyjs -o {f} {f}"
  f.writeFile userscriptHeader & "\n" & f.readFile
