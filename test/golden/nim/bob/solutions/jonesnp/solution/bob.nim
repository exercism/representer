import strutils
import sequtils

proc hey*(prompt: string) :string =
  var str = strip(prompt)
  if str == "":
    return "Fine. Be that way!"
  elif str[^1] == '?' and str == toUpperAscii(str) and any(str, isAlphaAscii):
    return "Calm down, I know what I'm doing!"
  elif str[^1] == '?':
    return "Sure."
  elif not any(str, isAlphaAscii):
    return "Whatever."
  elif str == toUpperAscii(str):
    return "Whoa, chill out!"
  else:
    return "Whatever."