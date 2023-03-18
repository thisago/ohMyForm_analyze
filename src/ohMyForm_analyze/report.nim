from std/tables import Table, `[]`
from std/json import items, `{}`, JsonNode, len
from std/strformat import fmt
from std/strutils import multiReplace, parseInt
from std/uri import decodeUrl
import karax / [karaxdsl, vdom]

import ohMyForm_analyze/core

proc createReport*(scores: Table[string, string]; entry: JsonNode): string =
  var
    total = 0
    numFields = 0
  let vnode = buildHtml(table):
    tr:
      th: text "Name"
      th: text "Value"
      th: text "Score"
    var i = -1
    for field in entry{"fields"}:
      inc i
      try:
        let score = scores.getScore $i
        total += score.parseInt
        inc numFields
        tr:
          th: text field{"field", "title"}.getStr
          th: text field{"value"}.getStr
          th: text score
      except ValueError:
        discard
    let nflds = numFields / 10
    h1: text fmt"Total: {total} ÷ {nflds} = {total.float / nflds}%"
        

  proc clean(s: string): string =
    s.multiReplace({
      "</#text>": "",
      "<#text>": "",
      "\n": "",
      "  ": " "
    })
  result = """<style>
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {background-color: #f2f2f2;}
</style>
""".clean
  result.add decodeUrl ($($vnode)).clean
  echo result
