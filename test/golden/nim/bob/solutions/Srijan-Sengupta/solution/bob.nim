import std/strutils

proc isQuestioning(sentence: string):bool
proc isYelling(sentence: string):bool

proc hey*(sentence: string):string =
  if sentence.isEmptyOrWhitespace():
    return "Fine. Be that way!"
  elif sentence.isYelling():
    if sentence.isQuestioning():
      return "Calm down, I know what I'm doing!"
    else:
      return "Whoa, chill out!"
  elif sentence.isQuestioning():
    return "Sure." 
  else:
    return "Whatever."

proc isYelling(sentence: string): bool =
  var numberOfAlpha = 0

  for c in sentence:
    if c.isAlphaAscii():
      numberOfAlpha+=1
      if c.isLowerAscii() :
        return false

  return numberOfAlpha>0

proc isQuestioning(sentence: string):bool =
  return sentence.strip()[^1] == '?'
