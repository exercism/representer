import std/intsets

proc sum*(limit: int, factors: openArray[int]): int =
  var multiples = IntSet()

  for factor in factors:
    if factor != 0:
      let maxNrOfMult = (limit-1) div factor

      for i in 1..maxNrOfMult:
        let multiple = factor * i
        if not multiples.containsOrIncl(multiple):
          result += multiple