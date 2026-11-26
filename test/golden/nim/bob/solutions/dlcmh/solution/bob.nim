import re, strutils
  
proc hey*(s: string): string =
  let t = s.strip
  let noLetters = t.findAll(re"[\d\W]").len == t.len
  let isQuestion = t.endsWith("?")
  let isShouting = t.toUpperAscii == t and not noLetters

  if (not isShouting and isQuestion) or (noLetters and isQuestion):
    return "Sure."
  elif t == "":
    return "Fine. Be that way!"
  elif isShouting and isQuestion:
    return "Calm down, I know what I'm doing!"
  elif isShouting:
    return "Whoa, chill out!"
  elif noLetters:
    return "Whatever."
  else:
    return "Whatever."