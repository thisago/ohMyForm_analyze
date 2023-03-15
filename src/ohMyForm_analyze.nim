# from std/dom import document, querySelector
import std/dom
from std/jsffi import `[]`, to
from std/strutils import contains
from std/json import parseJson, items, `{}`, JsonNode, len
from std/json import `$`
from std/strformat import fmt
from std/tables import Table, `[]`, `[]=`, hasKey
from std/base64 import decode, encode

include pkg/karax/prelude

import pkg/jsFetchMock
from pkg/util/forStr import tryParseInt
from pkg/util/forHtml import genClass

import ohMyForm_analyze/[core, urlHash, report]


var
  entries: JsonNode
  selectedEntries: seq[int]
  minFieldsToShow = 10
  score: Table[string, int]

proc openReport(html: string) =
  discard window.open(fmt"https://code.ozzuu.com?fullscreen=true#{encode html}", "_blank")


# Draw new interface
proc draw: VNode =
  let fields = entries{currEntry}{"fields"} 
  var
    lastId = ""
    i = 0
  if currField.len == 0:
    let id = fields{0}.getId
    setHash fmt"analyze-{currPage}-{currEntry}-{id}"
  result = buildHtml(tdiv):
    if analyzing:
      a(href = fmt"#{currPage}-{currEntry}", draggable = "false"):
        text "Cancel analysis"
        proc onclick(ev: Event; el: VNode) =
          waitToRefreshHash(200)
      tdiv(class = "analysis"):
        tdiv(class = "fields"):
          for field in fields:
            let
              id = field.getId
              nextId = fields{i + 1}.getId
            tdiv(class = genClass({"field": true, "hidden": currField != id})):
              let name = field{"field", "title"}.getStr
              span: text name
              input(`type` = "text", readonly = "true",
                    value = field{"value"}.getStr)
              input(`type` = "number", placeholder = "Score",
                    value = score.getScore id):
                proc oninput(ev: Event; el: VNode) =
                  score[id] = tryParseInt $el.value
              tdiv(class = "controls"):
                if lastId.len > 0:
                  a(href = fmt"#analyze-{currPage}-{currEntry}-{lastId}"):
                    text "Back"
                else:
                  tdiv()
                if nextId.len > 0:
                  a(href = fmt"#analyze-{currPage}-{currEntry}-{nextId}"):
                    text "Next"
                else:
                  a:
                    text "Open report"
                    proc onclick(ev: Event; el: VNode) =
                      openReport createReport(score, entries{currEntry})
            lastId = id
            inc i
    else:
      tdiv(class = "config"):
        h2: text fmt"Configs"
        tdiv(class = "field"):
          span: text "Minimum of fields in entries"
          input(`type` = "number", value = $minFieldsToShow):
            proc oninput(ev: Event; el: VNode) =
              minFieldsToShow = tryParseInt $el.value
      tdiv(class = "entries"):
        h2: text fmt"Page {currPage} ({entries.len} per page). Selected entry {currEntry}"
        var i = 0
        for entry in entries:
          if entry{"fields"}.len < minFieldsToShow: continue
          inc i
          tdiv(class = "entry", id = fmt"{currPage}-{i}"):
            a(href = fmt"#{currPage}-{i}", draggable = "false"): text "+"
            tdiv(class = "fields"):
              for field in entry{"fields"}:
                tdiv(class = "field"):
                  let name = field{"field", "title"}.getStr
                  span: text name
                  input(`type` = "text", readonly = "true",
                        value = field{"value"}.getStr)
            a(href = fmt"#analyze-{currPage}-{i}", draggable = "false"): text "Analyze"

var firstTime = true

discard newFetchMock("submissions"):
  if "operationName\":\"listSubmissions" in $configs["body"].to cstring:
    entries = parseJson($body){"data", "pager", "entries"}

    # draw new UI
    if firstTime:
      # remove old interface
      let baseEl = document.querySelector(".ant-table-content")
      cast[Node](baseEl).id = "ROOT"
      baseEl.innerHTML = ""
      
      setRenderer draw
      firstTime = false
      refreshHash()

    redraw()
    # return "{}"

# Styling
document.addEventListener("DOMContentLoaded", proc (ev: Event) =
  var style = document.createElement("style")
  style.innerHTML = "CSSCODEHERE".decode.cstring
  document.head.appendChild style
)
