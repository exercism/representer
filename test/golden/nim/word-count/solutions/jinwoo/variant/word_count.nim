import std/sequtils, std/strutils, std/tables

proc unquote(str: string): string =
  str.strip(chars = {'\''})

proc countWords*(s: string): Table[string, int] =
  let parts = s.toLower.split(Whitespace + PunctuationChars + {'\''})
                       .map(unquote)
  for word in parts:
    if word == "":
      continue
    if word in result:
      inc(result[word])
    else:
      result[word] = 1
