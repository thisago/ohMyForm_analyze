from std/json import JsonNode, `{}`
from std/strutils import strip, Whitespace
from std/tables import Table, `[]`, hasKey

proc getStr*(n: JsonNode): cstring =
  cstring json.getStr(n).strip(chars = Whitespace + {'"'})

proc getId*(node: JsonNode): string {.inline.} =
  $node{"field", "id"}.getStr
proc getScore*(t: Table[string, int]; id: string): string {.inline.} =
  result = ""
  if t.hasKey id:
    result = $t[id]
