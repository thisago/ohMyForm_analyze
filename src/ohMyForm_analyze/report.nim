from std/tables import Table, `[]`
from std/json import items, `{}`, JsonNode, len
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

  result = $ $vnode
  echo result
