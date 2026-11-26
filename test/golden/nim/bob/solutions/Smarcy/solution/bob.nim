import sequtils, strutils

proc inputOnlyLetters(input: string): string =
  for c in input:
    if c.isAlphaAscii:
      result.add(c)

proc hey*(input: string): string =

  if input.strip() == "": return "Fine. Be that way!"

  if inputOnlyLetters(input).allIt(it.isUpperAscii) and inputOnlyLetters(
      input) != "":
    if input.strip()[^1] == '?':
      return "Calm down, I know what I'm doing!"
    else:
      return "Whoa, chill out!"

  if input.strip()[^1] == '?':
    return "Sure."

  return "Whatever."
