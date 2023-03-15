from std/dom import window, querySelector, click, addEventListener, Event,
                      setTimeout
from std/strutils import split

from pkg/util/forStr import tryParseInt

var
  currPage* = 1
  currEntry* = 1
  analyzing* = false
  currField* = ""

proc refreshHash* =
  let hash = window.location.hash
  window.location.hash = ""
  discard window.setTimeout(proc = window.location.hash = hash, 0)

proc processHash* =
  let hash = $window.location.hash
  if '-' notin hash:
    window.location.hash = "1-1"
    return
  let parts = hash[1..^1].split "-"
  case parts.len:
  of 2:
    currPage = parts[0].tryParseInt
    currEntry = parts[1].tryParseInt
    analyzing = false
  of 3, 4:
    analyzing = parts[0] == "analyze"
    currPage = parts[1].tryParseInt
    currEntry = parts[2].tryParseInt
    if parts.len == 4:
      currField = parts[3]
  else: discard

window.addEventListener("hashchange", proc (ev: Event) = processHash())
processHash()

proc waitToRefreshHash*(ms = 0) =
  discard window.setTimeout(proc = refreshHash(), ms)
proc setHash*(hash: string; ms = 0) =
  discard window.setTimeout(proc = window.location.hash = hash, ms)
  
