# from std/dom import document, querySelector
import std/dom
from std/jsffi import `[]`, to
from std/strutils import contains
from std/json import parseJson, items, `{}`, JsonNode, len
from std/json import `$`
from std/strformat import fmt
from std/tables import Table, `[]`, `[]=`, hasKey, initTable
from std/base64 import decode, encode

include pkg/karax/prelude

import pkg/jsFetchMock
from pkg/util/forStr import tryParseInt

import ohMyForm_analyze/[core, urlHash, report]


var
  entries: JsonNode
  selectedEntries: seq[int]
  minFieldsToShow = 10
  scores: Table[string, string]
  analyzed = 0

proc openReport(html: string) =
  discard window.open(fmt"https://code.ozzuu.com?fullscreen=true#{encode html}", "_blank")

proc updateCurrField(field = currField) {.inline.} =
  setHash fmt"analyze-{currPage}-{currEntry}-{field}"

# Draw new interface
proc draw: VNode =
  var fields: JsonNode
  if analyzing:
    fields = entries{currEntry - 1}{"fields"} 
    if analyzed == 0 or currField.len == 0:
      updateCurrField(fields{0}.getId)
  result = buildHtml(tdiv):
    if analyzing:
      a(href = fmt"#{currPage}-{currEntry}"):
        text "Cancel analysis"
        proc onclick(ev: Event; el: VNode) =
          waitToRefreshHash(200)
          scores = initTable[string, string]()
          analyzed = 0
      tdiv(class = "analysis"):
        progress(value = $(analyzed / (fields.len - 1)))
        tdiv(class = "fields"):
          proc scoreIsValid(id: string): bool =
            let
              score = scores.getScore id
              num = score.tryParseInt(-11)
            result = score.len > 0 and num >= -10 and num <= 10
            
          for i in 0..<fields.len:
            let
              field = fields{i}
              id = field.getId
            if currField != id: continue
            let
              nextId = fields{i + 1}.getId
              lastId = if i > 0: fields{i - 1}.getId else: ""
            tdiv(class = "field"):
              let name = field{"field", "title"}.getStr
              span: text name
              input(`type` = "text", readonly = "true",
                    value = field{"value"}.getStr)
              input(`type` = "number", placeholder = "Score", `data-id` = id,
                      selected = "true", max = "10", min = "-10"):
                proc oninput(ev: Event; el: VNode) =
                  scores[$el.getAttr("data-id")] = $el.value
                proc onkeydown(ev: Event; el: VNode) =
                  if cast[KeyboardEvent](ev).key == "Enter":
                    if scoreIsValid $el.getAttr("data-id"):
                      echo fmt"{analyzed=} {fields.len=}"
                      if analyzed == fields.len - 1:
                        openReport createReport(scores, entries{currEntry})
                      else:
                        inc analyzed
                        updateCurrField(nextId)
              tdiv(class = "controls"):
                if lastId.len > 0:
                  a(href = fmt"#analyze-{currPage}-{currEntry}-{lastId}"):
                    text "Back"
                    proc onclick(ev: Event; el: VNode) =
                      dec analyzed
                else:
                  tdiv()
                if nextId.len > 0:
                  if scoreIsValid id:
                    a(href = fmt"#analyze-{currPage}-{currEntry}-{nextId}"):
                      text "Next"
                      proc onclick(ev: Event; el: VNode) =
                        inc analyzed
                  else:
                    span: text "Next"
                else:
                  if scoreIsValid id:
                    a:
                      text "Open report"
                      proc onclick(ev: Event; el: VNode) =
                        openReport createReport(scores, entries{currEntry - 1})
                  else:
                    span: text "Open report"
    else:
      # List
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
          inc i
          if entry{"fields"}.len < minFieldsToShow: continue
          tdiv(class = "entry", id = fmt"{currPage}-{i}"):
            a(href = fmt"#{currPage}-{i}"): text "+"
            a(href = fmt"#analyze-{currPage}-{i}"): text "Analyze"
            tdiv(class = "fields"):
              for field in entry{"fields"}:
                tdiv(class = "field"):
                  let name = field{"field", "title"}.getStr
                  span: text name
                  input(`type` = "text", readonly = "true",
                        value = field{"value"}.getStr)

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
