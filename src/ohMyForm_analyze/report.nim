from std/tables import Table, `[]`
from std/json import items, `{}`, JsonNode, len
from std/strutils import multiReplace
from std/uri import decodeUrl
import karax / [karaxdsl, vdom]

import ohMyForm_analyze/core

proc createReport*(scores: Table[string, int]; entry: JsonNode): string =
  let vnode = buildHtml(table):
    tr:
      th: text "Name"
      th: text "Value"
      th: text "Score"
    for field in entry{"fields"}:
      tr:
        th: text field{"field", "title"}.getStr
        th: text field{"value"}.getStr
        th: text $scores.getScore field.getId
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
"""
  result.add decodeUrl ($($vnode)).multiReplace({
    "</#text>": "",
    "<#text>": "",
    "\n": "",
    "  ": " "
  })
  echo result
