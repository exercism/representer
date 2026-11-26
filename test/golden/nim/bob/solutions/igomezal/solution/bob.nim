import std/strutils

proc hey*(s: string): string =
  let upperString = toUpperAscii(s)
  let stripString = strip(s)
  let lastCharacter = (if len(stripString) == 0: ' ' else: stripString[^1])


  if isEmptyOrWhitespace(s):
    "Fine. Be that way!"
  elif '?' == lastCharacter and upperString == s and s.contains(Letters):
    "Calm down, I know what I'm doing!"
  elif '?' == lastCharacter:
    "Sure."
  elif upperString == s and s.contains(Letters):
    "Whoa, chill out!"
  else:
    "Whatever."



