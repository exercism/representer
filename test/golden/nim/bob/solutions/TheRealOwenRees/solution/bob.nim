from std/strutils import endsWith, strip
from std/unicode import isLower, isUpper, isWhiteSpace, runes

func isSilence(s: string): bool =
  for r in runes(s):
    if not isWhiteSpace(r):
      return false
  return true

func isYelling(s: string): bool =
  var nUpperRunes = 0
  for r in runes(s):
    if isLower(r):
      return false
    elif isUpper(r):
      inc(nUpperRunes)
  return nUpperRunes > 0

func isQuestion(s: string): bool =
  return s.strip().endsWith("?")

func hey*(msg: string): string =
  if isSilence(msg):
    return "Fine. Be that way!"
  elif isQuestion(msg):
    if isYelling(msg):
      return "Calm down, I know what I'm doing!"
    else:
      return "Sure."
  elif isYelling(msg):
    return "Whoa, chill out!"
  else:
    return "Whatever."