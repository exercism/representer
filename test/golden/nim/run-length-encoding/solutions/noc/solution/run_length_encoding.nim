from strutils import repeat, parseInt
import nre

proc encode*(s: string): string =
  var l = newSeq[tuple[letter: char, count: int]](0)
  for x in s:
    if l.len < 1 or l[^1].letter != x: l.add((letter: x, count: 1))
    else: l[^1].count += 1
  for x in l:
    if x.count > 1: result &= $x.count
    result &= x.letter

proc decode*(s: string): string =
  let selector = re"(\d*)(.)"
  for x in s.findIter(selector):
    result &= ($x)[^1].repeat(if ($x)[0 .. ^2].len > 0: ($x)[0 .. ^2].parseInt
                              else: 1)
