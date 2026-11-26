import std/strutils

proc isQuestion(s: string): bool =
  result = s[^1] == '?'

proc isAllCapitalLetters(s: string): bool =
  for c in s:
    if isAlphaAscii(c):
      result = true

      if not isUpperAscii(c):
        result = false

        break

proc hey*(s: string): string =
  let s = strip(s)

  if s == "":
    result = "Fine. Be that way!"
  elif isQuestion(s) and isAllCapitalLetters(s):
    result = "Calm down, I know what I'm doing!"
  elif isQuestion(s):
    result = "Sure."
  elif isAllCapitalLetters(s):
    result = "Whoa, chill out!"
  else:
    result = "Whatever."