import strutils
  
proc question(s: string): bool {.inline, noSideEffect.} =
  assert s[^1] notin Whitespace
  s[^1] == '?'

proc allCaps(s: string): bool =
  var atLeastOneCapital = false
  for c in s.items:
    if c.isLowerAscii:
      return false
    if c.isUpperAscii:
      atLeastOneCapital = true
  return atLeastOneCapital

proc hey*(line: string): string =
  let line = line.strip # for testing last char in question() and easy whitespace test
  if line.len == 0:    "Fine. Be that way!"
  elif allCaps(line):
    if question(line): "Calm down, I know what I'm doing!"
    else:              "Whoa, chill out!"
  elif question(line): "Sure."
  else:                "Whatever."