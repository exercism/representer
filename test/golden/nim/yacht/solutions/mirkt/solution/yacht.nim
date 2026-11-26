import std/[tables, algorithm, math]
type
  Category* = enum
    Ones = 1, Twos, Threes, Fours, Fives, Sixes,
    FullHouse, FourOfAKind, LittleStraight, BigStraight, Choice, Yacht

proc score*(dice: array[5, int], cat: Category): int =
  let d = dice.toCountTable
  case cat:
    of Ones..Sixes: d[cat.ord] * cat.ord
    of FullHouse:
      if d.len == 2 and d.smallest.val == 2: dice.sum else: 0
    of FourOfAKind:
      if d.largest.val > 3: d.largest.key.ord * 4 else: 0
    of LittleStraight:
      if dice.sorted == @[1, 2, 3, 4, 5]: 30 else: 0
    of BigStraight:
      if dice.sorted == @[2, 3, 4, 5, 6]: 30 else: 0
    of Choice: dice.sum
    of Yacht:
      if d.len == 1: 50 else: 0
