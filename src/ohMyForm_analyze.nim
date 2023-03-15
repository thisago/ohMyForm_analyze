from std/jsffi import `[]`, to
from std/strutils import contains
from std/json import parseJson, items, getStr, `{}`, `$`

import pkg/jsFetchMock

discard newFetchMock("submissions"):
  if "\"operationName\":\"listSubmissions\"" in $configs["body"].to cstring:
    let node = parseJson $body
    for entry in node{"data", "pager", "entries"}:
      for field in entry{"fields"}:
        echo field
    return "{}"
