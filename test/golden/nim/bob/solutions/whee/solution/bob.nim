import std/strutils

func isQuestion(s: string): bool =
  s.endsWith '?'

func isYelling(s: string): bool =
  var hadUpper = false
  result = true
  for c in s:
    if c.isUpperAscii:
      hadUpper = true
    elif c.isLowerAscii:
      result = false
      break
  result = hadUpper and result

func hey*(s: string): string =
  let input = s.strip

  if input.isEmptyOrWhitespace:
    result = "Fine. Be that way!"
  elif input.isQuestion and input.isYelling:
    result = "Calm down, I know what I'm doing!"
  elif input.isQuestion:
    result = "Sure."
  elif input.isYelling:
    result = "Whoa, chill out!"
  else:
    result = "Whatever."
