import strutils

proc isAlphaStr(s: string): bool =
  for c in s:
    if c.isAlphaAscii(): return true
  false

proc hey*(st: string): string =
  let s = strip(st)
  if s == "": return "Fine. Be that way!"
  let q: bool = s[^1] == '?'
  let c: bool = isAlphaStr(s) and s.toUpperAscii() == s
  if q:
    if c: "Calm down, I know what I'm doing!"
    else: "Sure."
  elif c: "Whoa, chill out!"
  else: "Whatever."