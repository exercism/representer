import std/strutils
  
const ones = ['I', 'X', 'C', 'M']
const fifths = ['V', 'L', 'D']
  
proc roman*(n: int): string =
  let nStr = $n 
  for i, c in nStr:
    let pos = nStr.high - i
    let val = parseInt($c)
    if pos == 3: result.add repeat(ones[pos], val)
    else:
      case val:
        of 1..3: result.add repeat(ones[pos], val)
        of 4: result.add ones[pos] & fifths[pos]
        of 5: result.add fifths[pos]
        of 6..8: result.add fifths[pos] & repeat(ones[pos], val-5)
        of 9: result.add ones[pos] & ones[pos+1]
        of 0: discard
        else: raise newException(ValueError, "not a digit")
    
