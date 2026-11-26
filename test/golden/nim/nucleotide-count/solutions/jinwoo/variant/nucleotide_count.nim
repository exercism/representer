import std/[strformat, tables]

proc countDna*(s: string): CountTable[char] =
  for c in s:
    if c in "ACGT":
      result.inc(c)
    else:
      raise newException(ValueError, &"invaljd DNA: {c}")
