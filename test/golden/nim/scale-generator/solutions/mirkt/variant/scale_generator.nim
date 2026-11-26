import std/[sequtils, strutils]

const
  sharps = "A A# B C C# D D# E F F# G G#".split
  flats = "A Bb B C Db D Eb E F Gb G Ab".split
  flatmode = ["F", "Bb", "Eb", "Ab", "Db", "Gb", "d", "g", "c", "f", "bb", "eb"]

proc scale*(tonic: string, intervals: string): seq[string] =
  let scale = if tonic in flatmode: flats.cycle(3) else: sharps.cycle(2)
  var p = scale.find(tonic.capitalizeAscii)
  result &= scale[p]
  for s in intervals:
    p += " mMA".find(s)
    result &= scale[p]
