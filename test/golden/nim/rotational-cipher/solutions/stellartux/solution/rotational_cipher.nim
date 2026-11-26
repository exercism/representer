import std/sequtils, std/strutils

proc rotate*(s: string, n: int): string =
  let key = n mod 26
  s.map(
    proc (c: char): char = 
      if isAlphaAscii(c):
        let d = (c.ord + key).chr
        if isUpperAscii(c) == isUpperAscii(d) and isLowerAscii(c) == isLowerAscii(d):
          d
        else:
          (c.ord + key - 26).chr
      else:
        c).join
  
