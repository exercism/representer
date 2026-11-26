import std/[strutils, sequtils, re]

proc abbreviate*(s: string): string =
  s.split(re"[\s_-]+")
    .mapIt(it[1].toUpperAscii)
    .join("")
