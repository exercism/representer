import math, sequtils, sets, tables

type Category* = enum
    Ones = 1, Twos, Threes, Fours, Fives, Sixes,
    FullHouse, FourOfAKind, LittleStraight, BigStraight, Choice, Yacht

proc score*(ds: array[0 .. 4, int], cat: Category): int =
  let ct = toCountTable[int](ds)
  case cat
  of Ones .. Sixes: 
    result = ct[cat.int] * cat.int
  of Choice: 
    result = toSeq(ct.pairs).mapIt(it[0]*it[1]).sum
  of FourOfAKind: 
    result = toSeq(ct.keys).filterIt(ct[it] >= 4).mapIt(4*it).sum
  of FullHouse: 
    if toHashSet([2, 3]) == toHashSet(toSeq(ct.values)): 
      result = toSeq(ct.pairs).mapIt(it[0]/it[1]).sum
  of LittleStraight: 
    if ct == toCountTable[int]([1, 2, 3, 4, 5]): 
      result = 30
  of BigStraight: 
    if ct == toCountTable[int]([2, 3, 4, 5, 6]): 
      result = 30
  of Yacht: 
    if toSeq(ct.values).allIt(it==5): 
      result = 50
