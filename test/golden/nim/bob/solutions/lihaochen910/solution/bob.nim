import strutils

proc hey*(input : string) : string =

  if input.isEmptyOrWhitespace:
    return "Fine. Be that way!"
  
  if {'A'..'Z'} in input:
    var allCharIsUpper = true
    for c in input:
      if isSpaceAscii c:
        continue
      if c in {'0'..'9'}:
        continue
      if (isAlphaAscii c) and (not isUpperAscii c):
        allCharIsUpper = false
        break

    if allCharIsUpper:
      if input.endsWith "?":
        return "Calm down, I know what I\'m doing!"
      return "Whoa, chill out!"

  if input.strip.endsWith "?":
    return "Sure."


  return "Whatever."