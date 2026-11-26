## This module solves Exercism's diamond exercise.

from std/strutils import join, repeat

func diamondLine(c, currentLetter: char): string =
  let prefix = ' '.repeat(c.int - currentLetter.int)
  if currentLetter == 'A':
    prefix & currentLetter & prefix & '\n'
  else:
    let infix = ' '.repeat((currentLetter.int - 'A'.int) * 2 - 1)
    prefix & currentLetter & infix & currentLetter & prefix & '\n'

proc diamond*(c: char): string =
  ## Creates a string that kind of looks like a diamond.
  var lines = newSeq[string]()
  for letter in 'A'..<c:
    lines.add(diamondLine(c, letter))
  for letter in countdown(c, 'A'):
    lines.add(diamondLine(c, letter))
  lines.join
