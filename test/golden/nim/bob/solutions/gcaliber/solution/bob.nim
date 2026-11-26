import std/[sequtils, strutils, sugar]
  
proc isQuestion(s: string): bool =
  let x = s.strip()
  return x[^1] == '?'
  
proc isYell(s: string): bool =
  let letters = s.filter(s => s.isAlphaAscii())
  if len(letters) == 0: return false
  for c in letters:
    if c.isLowerAscii():
      return false
  return true

proc hey*(s: string): string =
  if s.isEmptyOrWhitespace():
    return "Fine. Be that way!"

  let yell = isYell(s)
  let question = isQuestion(s)

  if yell and question:
    return "Calm down, I know what I'm doing!"
  if question:
    return "Sure."
  if yell:
    return "Whoa, chill out!"  

  return "Whatever."