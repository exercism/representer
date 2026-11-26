import std/algorithm
import std/strutils

proc reverse*(text:string):string=
  reversed(text).join("")