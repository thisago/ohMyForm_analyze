from std/json import JsonNode, `{}`
from std/strutils import strip, Whitespace
from std/tables import Table, `[]`, hasKey

proc getStr*(n: JsonNode): cstring =
  cstring json.getStr(n).strip(chars = Whitespace + {'"'})

proc getScore*(t: Table[string, string]; id: string): string {.inline.} =
  result = ""
  if t.hasKey id:
    result = t[id]
