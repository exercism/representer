import strutils, algorithm, sequtils

var
  numbers = toSeq('0'..'9')
  characters = toSeq('a'..'z')
  plain = characters & numbers
  cipher = characters.reversed & numbers

proc addSpaces(s: string): string =
  for i in 1..len(s):
    result = result & s[i-1]
    if i mod 5 == 0: result = result & " "
  return result.strip

proc encode*(s: string): string =
  for c in s.toLowerAscii:
    let index = plain.find(c)
    if index == -1:
      result = result & $cipher[index]
  return addSpaces(result)

proc decode*(s: string): string =
  for c in s.toLowerAscii:
    let index = cipher.find(c)
    if index != -1:
      result = result & $plain[index]

