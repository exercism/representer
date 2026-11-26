import tables

const symbols = toTable {
  1_000_000_000: " billion",
      1_000_000: " million",
          1_000: " thousand",
            100: " hundred",
  90: "ninety",
  80: "eighty",
  70: "seventy",
  60: "sixty",
  50: "fifty",
  40: "forty",
  30: "thirty",
  20: "twenty",
  19: "nineteen",
  18: "eighteen",
  17: "seventeen",
  16: "sixteen",
  15: "fifteen",
  14: "fourteen",
  13: "thirteen",
  12: "twelve",
  11: "eleven",
  10: "ten",
  9: "nine",
  8: "eight",
  7: "seven",
  6: "six",
  5: "five",
  4: "four",
  3: "three",
  2: "two",
  1: "one",
  0: "zero",
}

proc hundred(n: int): string =
  var x = n
  if x >= 100:
    result.add symbols[x div 100]
    result.add symbols[100]
    x = x mod 100
    if x == 0: return 
    result.add ' '

  if x notin symbols:
    result.add symbols[x - x mod 10]
    x = x mod 10
    result.add '-'

  result.add symbols[x]
   
proc say*(n: int64): string = 
  if n notin 0..<1_000_000_000_000:
    raise newException(ValueError, "out of bounds")

  if n == 0: return symbols[0]

  var x = n  
  for k in [1_000_000_000, 1_000_000, 1_000]:
    if x > k:
      result.add int(x div k).hundred
      result.add symbols[k]
      x = x mod k
      if x == 0: return
      result.add ' '

  result.add int(x).hundred
