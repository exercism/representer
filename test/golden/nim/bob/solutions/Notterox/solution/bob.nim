import strutils

proc isYelling(s: string): bool = s.allCharsInSet(AllChars - LowercaseLetters) and s.contains(UppercaseLetters)
proc isQuestion(s: string): bool = s.strip.endsWith("?")

proc hey*(s: string = ""): string =
  if s.isEmptyOrWhitespace:
    return "Fine. Be that way!"

  if s.isYelling:
    if s.isQuestion:
      return "Calm down, I know what I'm doing!"
    else:
      return "Whoa, chill out!"

  if s.isQuestion:
    return "Sure."
  
  return "Whatever."
