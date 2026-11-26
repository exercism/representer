import std/[strutils, sequtils]

func isYelling(s: string): bool =
  if s.any(isAlphaAscii):
    return s.all do (c: char) -> bool:
      (not c.isAlphaAscii) or c.isUpperAscii

func isQuestion(s: string): bool = s[^1] == '?'

func hey*(s: string): string =
  let ss = strip s
  if ss.isEmptyOrWhitespace():
    "Fine. Be that way!"
  elif ss.isQuestion:
    if ss.isYelling:
      "Calm down, I know what I'm doing!"
    else:
      "Sure."
  else:
    if ss.isYelling:
      "Whoa, chill out!"
    else:
      "Whatever."
