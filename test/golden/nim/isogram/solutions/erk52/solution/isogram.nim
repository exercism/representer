import std/strutils
  
proc isIsogram*(s: string): bool =
  var letters: seq[char] = @[]
  for c in s:
    if "abcdefghijklmnopqrstuvwxyz".contains(toLowerAscii(c)):
      if letters.contains(toLowerAscii(c)):
        return false
      letters.add(toLowerAscii(c))
  return true
  
