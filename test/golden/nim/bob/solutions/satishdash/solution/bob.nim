import std/strutils

proc isYelling(s: string): bool = 
  # All upper case alpha
  var foundAlpha : bool = false
  for ch in s:
    if ch.isAlphaAscii:
      foundAlpha = true
      if ch.isUpperAscii:
        continue
      else:
        return false
  return (true and foundAlpha)

proc isQuestion(s: string): bool = 
  return s.endsWith("?")

proc isYellingQuestion(s: string): bool = 
  return isQuestion(s) and isYelling(s)

proc hey*(s: string = ""): string = 
  let sanitizedStr: string = s.strip()

  if sanitizedStr == "":
    result = "Fine. Be that way!"

  elif isYellingQuestion(sanitizedStr):
    result = "Calm down, I know what I'm doing!"
  
  elif isQuestion(sanitizedStr):
    result = "Sure."

  elif isYelling(sanitizedStr):
    result = "Whoa, chill out!"

  else:
    result = "Whatever."