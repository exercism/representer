import std/strutils

proc isAQuestion(s: string): bool =
    s[^1] == '?'

proc isShouting(s: string): bool =
    s.toUpperAscii == s and
    s.find(Letters) >= 0

proc hey*(statement: string): string =
  let s = statement.strip

  if s.isEmptyOrWhitespace:
    "Fine. Be that way!"
  elif s.isAQuestion and 
       s.isShouting:
    "Calm down, I know what I'm doing!"
  elif s.isAQuestion:
    "Sure."
  elif s.isShouting:  # -1 is none found
    "Whoa, chill out!"
  else:
    "Whatever."