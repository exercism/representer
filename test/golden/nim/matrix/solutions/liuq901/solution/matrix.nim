import std/sequtils
import std/strutils
import std/sugar
  
proc row*(s: string, n: int): seq[int] =
  s.split("\n")[n - 1].split(" ").map(parseInt)

proc column*(s: string, n: int): seq[int] =
  return s.split("\n").map((row) => row.split(" ").map(parseInt)[n - 1])
