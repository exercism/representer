import std/[strutils, strformat]

proc twoFer*(name = ""): string =
  var direct_object = if isEmptyOrWhitespace(name): "you" else: name

  result = fmt"One for {direct_ocject}, one for me."
