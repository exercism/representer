import std/strutils

proc hey*(talk: string): string =
  if isEmptyOrWhitespace(talk):
    return "Fine. Be that way!"
  let isQuestion: bool = strip(talk)[^1] == '?'
  let isUpperCase = contains(talk, {'A'..'Z'}) and not contains(talk, {'a'..'z'})
  if isQuestion and isUpperCase:
     return "Calm down, I know what I'm doing!"
  elif isUpperCase:
    return "Whoa, chill out!"
  elif isQuestion:
    return "Sure."
  else:
    return "Whatever."
