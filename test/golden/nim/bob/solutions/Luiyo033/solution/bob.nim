from strutils import endsWith, strip, isEmptyOrWhitespace
from unicode import isLower,isUpper, runes

proc isUpper(text: string): bool =
  var nUpperRunes = 0
  for r in runes(text):
    if isLower(r):
      return false
    elif isUpper(r):
      inc(nUpperRunes)
  return nUpperRunes > 0

proc hey*(text: string): string =
  var text = strip(text)
  if isEmptyOrWhitespace(text):
    "Fine. Be that way!"
  elif text.endsWith("?"):
      if isUpper(text):
        "Calm down, I know what I'm doing!"
      else:
        "Sure."
  elif isUpper(text):
      "Whoa, chill out!"
  else: 
    "Whatever."