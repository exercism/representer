import strutils

proc isSilent(str: string): bool =
  if isEmptyOrWhitespace(strip(str)): #checks if string is empty
    true
  else:
    false

proc isYelling(str: string): bool =
    for c in strip(str):
      if contains(Letters,c) and isLowerAscii(c): #check if string has any lower case letters
        return false
    true

proc isQuestion(str: string): bool =
    if strip(str).endsWith("?"): #check if last char in string array
      true
    else:
      false

proc hasLetters(str: string): bool =
  for c in str:
    if contains(Letters,c):
      return true
  false

proc hey*(s: string): string =
  if isYelling(s) and isQuestion(s) and hasLetters(s):
    "Calm down, I know what I'm doing!" 
  elif isYelling(s) and not isSilent(s) and hasLetters(s):
    "Whoa, chill out!"
  elif isQuestion(s): 
    "Sure."
  elif isSilent(s):
    "Fine. Be that way!"
  else:
    "Whatever."

echo hey("4?")