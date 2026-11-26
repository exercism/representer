import sequtils, math, strutils

proc encrypt*(text: string): string =
  var ns = text.toLowerAscii().strip().toSeq().filterit(it.isAlphaNumeric()).mapIt($it)
  if ns == @[]: return ""
  let
    rows = ns.len().float.sqrt().ceil().int
    cols = (ns.len() / rows).round.int
    normalizedString = ns.foldl(a & b).alignLeft(rows * cols, ' ')
  for i in 0..<rows:
    for j in 0..<cols:
      result = result & $(normalizedString[i+j*rows])
    if i != rows-1: result = result & " "
