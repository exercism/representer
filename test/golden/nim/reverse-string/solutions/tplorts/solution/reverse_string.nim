import std/strutils
import std/algorithm

proc reverse*(s: string): string =
  return s.reversed.join("")
