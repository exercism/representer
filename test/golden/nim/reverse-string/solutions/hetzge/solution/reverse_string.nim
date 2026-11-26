import std/algorithm
import strutils
proc reverse*(input: string): string =
  input.reversed().join()